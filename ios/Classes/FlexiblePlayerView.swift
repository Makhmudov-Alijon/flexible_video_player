import Flutter
import UIKit
import AVFoundation
import AVKit

fileprivate extension CMTime {
    var isNumeric: Bool {
        let s = CMTimeGetSeconds(self)
        return !s.isNaN && s.isFinite
    }
}

class VideoContainerView: UIView {
    weak var playerLayer: AVPlayerLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        if let layer = playerLayer {
            layer.frame = bounds
        }
    }
}

class NativeVideoView: NSObject, FlutterPlatformView {
    private var _view: VideoContainerView
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var playerAsset: AVURLAsset?
    private var playerItem: AVPlayerItem?
    
    private var pipController: AVPictureInPictureController?
    private var pipPossibleObservation: NSKeyValueObservation?

    private let viewId: Int64
    private let channel: FlutterMethodChannel
    private let events: FlutterEventChannel
    private var eventSink: FlutterEventSink?
    private var timeObserverToken: Any?

    init(frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
        self.viewId = viewId
        self._view = VideoContainerView(frame: frame)
        self.channel = FlutterMethodChannel(name: "flexible_video_player_\(viewId)", binaryMessenger: messenger)
        self.events = FlutterEventChannel(name: "flexible_video_player_event", binaryMessenger: messenger)

        super.init()

        channel.setMethodCallHandler(handle)
        events.setStreamHandler(self)

        if let dict = args as? [String: Any], let url = (dict["initialUrl"] as? String) ?? (dict["url"] as? String) {
            setupPlayer(urlString: url)
        }
    }

    public func view() -> UIView { return _view }

    private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setUrl":
            if let args = call.arguments as? [String: Any], let url = args["url"] as? String {
                setupPlayer(urlString: url)
            }
            result(nil)

        case "play":
            DispatchQueue.main.async {
                self.player?.play()
            }
            result(nil)

        case "pause":
            DispatchQueue.main.async {
                self.player?.pause()
            }
            result(nil)

        case "seekTo":
            if let args = call.arguments as? [String: Any], let pos = args["position"] as? Int {
                let time = CMTimeMake(value: Int64(pos), timescale: 1000)
                player?.seek(to: time)
            }
            result(nil)

        case "setVolume":
            if let args = call.arguments as? [String: Any], let v = args["volume"] as? Double {
                player?.volume = Float(v)
            }
            result(nil)

        case "getTracks":
            // async getTracks
            getTracks { tracks in
                result(tracks)
            }
            return

        case "selectAudio":
            if let args = call.arguments as? [String: Any], let idx = args["index"] as? Int { selectAudio(index: idx) }
            result(nil)

        case "selectText":
            if let args = call.arguments as? [String: Any], let idx = args["index"] as? Int { selectText(index: idx) }
            result(nil)
            
        case "selectVideo":
            if let args = call.arguments as? [String: Any], let width = args["width"] as? Int , let height = args["height"] as? Int , let peakBitRate = args["peakBitRate"] as? Double{
                self.player?.currentItem?.preferredPeakBitRate = Double(peakBitRate)
                self.player?.currentItem?.preferredMaximumResolution = CGSize(width: width, height: height)
            }
            result(nil)

        case "setPreferredBitrate":
            if let args = call.arguments as? [String: Any], let kbps = args["kbps"] as? Int {
                player?.currentItem?.preferredPeakBitRate = Double(kbps) * 1000.0
            }
            result(nil)
            
        case "enterPictureInPicture":
            if let pip = pipController, pip.isPictureInPicturePossible {
                pip.startPictureInPicture()
                result(nil)
            } else {
                result(FlutterError(code: "PIP_NOT_POSSIBLE", message: "PiP currently not possible", details: nil))
            }

        case "exitPictureInPicture":
             if let pip = pipController, pip.isPictureInPictureActive {
                pip.stopPictureInPicture()
            }
            result(nil)
            
        case "dispose":
            dispose()
            result(nil)
            
        case "enterLandscape":
            OrientationController.forceLandscape()
            result(nil)

        case "exitPortrait":
            OrientationController.forcePortrait()
            result(nil)
            
        case "isFullscreen":
            if(OrientationController.getOrientation().isLandscape){
                result(true)
            }else if(OrientationController.getOrientation().isPortrait){
                result(false)
            }
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func setupPlayer(urlString: String) {
        
        self.cachedVideoOptions = []
        
        guard let url = URL(string: urlString) else { return }

        DispatchQueue.main.async {
            self.disposePlayer()

            self.playerAsset = AVURLAsset(url: url)
            self.playerItem = AVPlayerItem(asset: self.playerAsset!)
            let player = AVPlayer(playerItem: self.playerItem)
            self.player = player

            let layer = AVPlayerLayer(player: player)
            layer.videoGravity = .resizeAspect
            layer.frame = self._view.bounds
            // Keep strong reference
            self.playerLayer = layer
            self._view.playerLayer = layer
            self._view.layer.addSublayer(layer)
            self.player?.allowsExternalPlayback = true 
            


            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("AudioSession setup failed: \(error)")
            }
            
            if AVPictureInPictureController.isPictureInPictureSupported() {
                self.pipController = AVPictureInPictureController(playerLayer: layer)
                self.pipController?.delegate = self
            }
            

            let interval = CMTimeMake(value: 1, timescale: 2)
            self.timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
                guard let self = self else { return }
                let posMs = Int(CMTimeGetSeconds(time) * 1000)
                var durMs = 0
                if let d = self.player?.currentItem?.duration, d.isNumeric {
                    durMs = Int(CMTimeGetSeconds(d) * 1000)
                }
                self.eventSink?( ["id": self.viewId, "type": "position", "position": posMs, "duration": durMs] )
            }

            self.playerItem?.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidPlayToEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        }
    }
    
    private func setupPictureInPictureIfPossible() {
        guard let layer = self.playerLayer else { return }

        // ensure device supports PiP
        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            eventSink?(["id": viewId, "type": "pipPossible", "possible": false, "reason": "deviceDoesNotSupportPiP"])
            return
        }

        // make controller (if not already)
        if pipController == nil {
            pipController = AVPictureInPictureController(playerLayer: layer)
            pipController?.delegate = self

            // observe isPictureInPicturePossible changes
            pipPossibleObservation = pipController?.observe(\.isPictureInPicturePossible, options: [.initial, .new]) { [weak self] controller, change in
                guard let self = self else { return }
                let possible = change.newValue ?? false

                // debug info: send to flutter
                self.eventSink?(["id": self.viewId, "type": "pipPossible", "possible": possible])

                // optional: if false, include diagnostic info
                if !possible {
                    let playerHasItem = (self.player?.currentItem != nil)
                    let itemReady = (self.player?.currentItem?.status == .readyToPlay)
                    let videoTrackCount = self.player?.currentItem?.asset.tracks(withMediaType: .video).count ?? 0
                    self.eventSink?(["id": self.viewId, "type": "pipDiagnosis",
                                     "playerHasItem": playerHasItem,
                                     "itemReady": itemReady,
                                     "videoTrackCount": videoTrackCount])
                }
            }
        }
    }

    private func disposePlayer() {
        if let token = timeObserverToken { player?.removeTimeObserver(token); timeObserverToken = nil }
        player?.pause()
        player = nil

        pipController?.stopPictureInPicture()
        pipController = nil
        pipPossibleObservation = nil

        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        _view.playerLayer = nil
        
        OrientationController.forcePortrait()
        
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let item = object as? AVPlayerItem {
            if item.status == .readyToPlay {
                DispatchQueue.main.async {
                    self.player?.play()
                    self.setupPictureInPictureIfPossible()
                }
                // we can remove observer here if we don't need further updates
                item.removeObserver(self, forKeyPath: "status")
            } else if item.status == .failed {
                // handle error if needed
            }
        }
    }

    @objc private func itemDidPlayToEnd(_ notification: Notification) {
        eventSink?( ["id": viewId, "type": "state", "isPlaying": false] )
    }

    private func getTracks(completion: @escaping ([String: Any]) -> Void) {
        var result: [String: Any] = [:]
        guard let item = player?.currentItem else { completion(result); return }

        // audio
        if let audioGroup = item.asset.mediaSelectionGroup(forMediaCharacteristic: .audible) {
            let audio = audioGroup.options.enumerated().map { (idx, opt) -> [String: Any] in
                
                // metadata yig‘ish
                let metaDict: [String: String] = opt.commonMetadata.reduce(into: [:]) { acc, mdItem in
                    if let common = mdItem.commonKey?.rawValue,
                       let value = mdItem.stringValue ?? (mdItem.value as? String) {
                        acc[common] = value
                    } else if let identifier = mdItem.identifier?.rawValue,
                              let value = mdItem.stringValue ?? (mdItem.value as? String) {
                        acc[identifier] = value
                    } else if let keyStr = mdItem.key as? String,
                              let value = mdItem.stringValue ?? (mdItem.value as? String) {
                        acc[keyStr] = value
                    }
                }
                
                let title = metaDict["title"]
                    ?? metaDict["Title"]
                    ?? metaDict.first(where: { $0.key.lowercased().contains("title") })?.value
                
                // URI olish uchun (faqat HLS da ishlaydi)
                var uri: String? = nil
                if let propList = opt.propertyList() as? [String: Any] {
                    uri = propList["URI"] as? String
                }
                
                return [
                    "index": idx,
                    "label": opt.displayName,                // Russian_0, English_3
                    "language": opt.locale?.languageCode ?? "",
                    "extendedLang": opt.extendedLanguageTag ?? "",
                    "uri": uri ?? NSNull(),
                    "metaData": metaDict,
                    "title": title ?? NSNull()
                ]
            }
            result["audio"] = audio
        }




        // text
        if let textGroup = item.asset.mediaSelectionGroup(forMediaCharacteristic: .legible) {
            let text = textGroup.options.enumerated().map { (idx, opt) in
                ["index": idx, "label": opt.displayName, "language": opt.locale?.languageCode ?? ""] as [String: Any]
            }
            result["text"] = text
        }
        
        
        func fetchVideoVariants(for asset: AVAsset, completionVariants: @escaping ([[String: Any]]) -> Void) {
            guard let urlAsset = asset as? AVURLAsset else {
                parseMasterPlaylistFallback(for: asset, completion: completionVariants)
                return
            }

            if #available(iOS 15.0, *) {
                Task {
                    do {
                        let variants: [AVAssetVariant] = try await urlAsset.load(.variants)
                        var arr: [[String: Any]] = []
                        for variant in variants {
                            if let size = variant.videoAttributes?.presentationSize, size.width > 0, size.height > 0 {
                                let dict: [String: Any] = [
                                    "width": Int(size.width),
                                    "height": Int(size.height),
                                    "peakBitrate": variant.peakBitRate ?? 0.0,
                                    "averageBitrate": variant.averageBitRate ?? 0.0
                                ]
                                arr.append(dict)
                            }
                        }
                        completionVariants(arr)
                    } catch {
                        parseMasterPlaylistFallback(for: urlAsset, completion: completionVariants)
                    }
                }
            } else {
                parseMasterPlaylistFallback(for: urlAsset, completion: completionVariants)
            }
        }


        func parseMasterPlaylistFallback(for asset: AVAsset, completion: @escaping ([[String: Any]]) -> Void) {
            guard let urlAsset = asset as? AVURLAsset else {
                completion([])
                return
            }
            let url = urlAsset.url
            let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)

            URLSession.shared.dataTask(with: req) { data, response, error in
                guard let data = data, let text = String(data: data, encoding: .utf8) else {
                    completion([])
                    return
                }

                let pattern = #"RESOLUTION=(\d+)x(\d+)"#
                guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
                    completion([])
                    return
                }
                let ns = text as NSString
                let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: ns.length))
                var seen = Set<String>()
                var arr: [[String: Any]] = []
                for m in matches {
                    if m.numberOfRanges == 3 {
                        let wStr = ns.substring(with: m.range(at: 1))
                        let hStr = ns.substring(with: m.range(at: 2))
                        let key = "\(wStr)x\(hStr)"
                        if seen.contains(key) { continue } // avoid duplicates
                        seen.insert(key)
                        if let w = Int(wStr), let h = Int(hStr) {
                            arr.append(["width": w, "height": h])
                        }
                    }
                }
                completion(arr)
            }.resume()
        }

        fetchVideoVariants(for: item.asset) { videoArray in
            if !videoArray.isEmpty {
                result["video"] = videoArray
            } else {
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        
        result.merge(makeAudioInfo(player: player)) { (_, new) in new }
        result.merge(makeVideoInfo(player: player)) { (_, new) in new }
        
    }

    
    private func fetchVideoOptionsFromMasterPlaylist(url: URL, completion: @escaping ([QualityOption]) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, resp, err in
            var parsed: [QualityOption] = []
            defer { DispatchQueue.main.async { completion(parsed) } }

            guard let data = data, let text = String(data: data, encoding: .utf8) else {
                return
            }

            
            let lines = text.split(separator: "\n").map { String($0) }
            var i = 0
            var idx = 0
            while i < lines.count {
                let raw = lines[i].trimmingCharacters(in: .whitespaces)
                if raw.hasPrefix("#EXT-X-STREAM-INF:") {
                    let attrs = raw.replacingOccurrences(of: "#EXT-X-STREAM-INF:", with: "")

                    var bandwidth: Int? = nil
                    if let bwRange = attrs.range(of: "BANDWIDTH=") {
                        let after = attrs[bwRange.upperBound...]
                        if let comma = after.firstIndex(of: ",") {
                            bandwidth = Int(String(after[..<comma]))
                        } else {
                            bandwidth = Int(String(after))
                        }
                    }

                    var resolution: String? = nil
                    if let rRange = attrs.range(of: "RESOLUTION=") {
                        let after = attrs[rRange.upperBound...]
                        if let comma = after.firstIndex(of: ",") {
                            resolution = String(after[..<comma])
                        } else {
                            resolution = String(after)
                        }
                    }

                    var uriLine: String? = nil
                    var j = i + 1
                    while j < lines.count {
                        let candidate = lines[j].trimmingCharacters(in: .whitespaces)
                        if candidate.isEmpty { j += 1; continue }
                        if candidate.hasPrefix("#") { break } // safety
                        uriLine = candidate
                        break
                    }

                    if let u = uriLine {
                        let fullUri: String?
                        if let candidate = URL(string: u), candidate.scheme != nil {
                            fullUri = candidate.absoluteString
                        } else {
                            fullUri = URL(string: u, relativeTo: url)?.absoluteString
                        }
                        parsed.append(QualityOption(index: idx, bitrate: bandwidth, resolution: resolution, uri: fullUri))
                        idx += 1
                    }
                }
                i += 1
            }
        }
        task.resume()
    }

    private func fetchVideoOptions(for url: URL, completion: @escaping ([QualityOption]) -> Void) {

        fetchVideoOptionsFromMasterPlaylist(url: url) { options in
            self.cachedVideoOptions = options
            completion(options)
        }
        
        
    }


    func makeAudioInfo(player: AVPlayer?) -> [String: Any] {
        var audioInfo: Any = NSNull()

        guard let item = player?.currentItem else {
            return ["audio_current": audioInfo]
        }

        if let group = item.asset.mediaSelectionGroup(forMediaCharacteristic: .audible) {
            let selectedOption = item.currentMediaSelection.selectedMediaOption(in: group)
            if let opt = selectedOption {
                var optInfo: [String: Any] = [:]
                optInfo["displayName"] = opt.displayName

                if let locale = opt.locale {
                    optInfo["localeIdentifier"] = locale.identifier
                    if let lang = locale.languageCode { optInfo["languageCode"] = lang }
                    if let region = locale.regionCode { optInfo["regionCode"] = region }
                } else if let tag = opt.extendedLanguageTag {
                    optInfo["languageTag"] = tag
                }

                let stringMetadata = opt.commonMetadata
                    .compactMap { item -> (String, String)? in
                        guard let key = item.commonKey?.rawValue, let value = item.stringValue else { return nil }
                        return (key, value)
                    }
                if !stringMetadata.isEmpty {
                    var metaDict: [String: String] = [:]
                    for (k, v) in stringMetadata { metaDict[k] = v }
                    optInfo["metadata"] = metaDict
                }

                audioInfo = optInfo
            } else {
                audioInfo = NSNull()
            }
        }

        return ["audio_current": audioInfo]
    }
    
    func makeVideoInfo(player: AVPlayer?) -> [String: Any] {
        var videoInfo: [String: Any] = [:]

        guard let item = player?.currentItem else {
            return ["video_current": NSNull()]
        }

        let peak = item.preferredPeakBitRate
        let maxRes = item.preferredMaximumResolution

        videoInfo["preferredPeakBitRate"] = (peak > 0) ? peak : NSNull()

        if maxRes != .zero {
            videoInfo["preferredMaximumResolution"] = [
                "width": Double(maxRes.width),
                "height": Double(maxRes.height)
            ]
        } else {
            videoInfo["preferredMaximumResolution"] = NSNull()
        }

//        if let last = item.accessLog()?.events.last {
//            videoInfo["observedBitRate"] = last.observedBitRate   // Double
//            videoInfo["observedMaxBitrate"] = last.observedMaxBitrate
//            videoInfo["numberOfStalls"] = last.numberOfStalls
//        } else {
//            videoInfo["observedBitRate"] = NSNull()
//            videoInfo["observedMaxBitrate"] = NSNull()
//            videoInfo["numberOfStalls"] = NSNull()
//        }

        return ["video_current": videoInfo]
    }

    private func selectAudio(index: Int) {
        guard let item = player?.currentItem,
              let group = item.asset.mediaSelectionGroup(forMediaCharacteristic: .audible),
              index >= 0, index < group.options.count else { return }
        let option = group.options[index]
        item.select(option, in: group)
    }

    private func selectText(index: Int) {
        guard let item = player?.currentItem,
              let group = item.asset.mediaSelectionGroup(forMediaCharacteristic: .legible) else { return }
        if index == -1 { item.select(nil, in: group); return }
        guard index >= 0, index < group.options.count else { return }
        let option = group.options[index]
        item.select(option, in: group)
    }

    func dispose() {
        disposePlayer()
        NotificationCenter.default.removeObserver(self)
    }
    
    private var cachedVideoOptions: [QualityOption] = []
}

extension NativeVideoView: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if let dict = arguments as? [String: Any], let idArg = dict["id"] as? Int64, idArg != viewId { return nil }
        eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}

private struct QualityOption {
    let index: Int
    let bitrate: Int?        // bits/sec
    let resolution: String?  // "1280x720"
    let uri: String?         // variant playlist URL
    var label: String {
        if let r = resolution {
            return "\(r) — \(bitrate.map { "\($0/1000) kbps" } ?? "auto")"
        }
        return bitrate.map { "\($0/1000) kbps" } ?? "Auto"
    }
}

extension NativeVideoView: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        eventSink?(["id": viewId, "type": "pipEvent", "event": "willStart"])
    }

    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        eventSink?(["id": viewId, "type": "pipEvent", "event": "didStart"])
    }

    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        eventSink?(["id": viewId, "type": "pipEvent", "event": "failed", "error": error.localizedDescription])
    }

    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        eventSink?(["id": viewId, "type": "pipEvent", "event": "willStop"])
    }

    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        eventSink?(["id": viewId, "type": "pipEvent", "event": "didStop"])
    }

    func pictureInPictureControllerRestoreUserInterfaceForPictureInPicture(_ pictureInPictureController: AVPictureInPictureController,
                                                                           completionHandler: @escaping (Bool) -> Void) {
        // You can restore your Flutter UI if needed when PiP closes
        completionHandler(true)
    }
}
