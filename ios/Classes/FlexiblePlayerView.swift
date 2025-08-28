import Flutter
import UIKit
import AVFoundation

class VideoPlayerTexture: NSObject, FlutterTexture, FlutterStreamHandler {
    private let textureRegistry: FlutterTextureRegistry
    private(set) var textureId: Int64 = -1
     var player: AVPlayer?
    private var videoOutput: AVPlayerItemVideoOutput?
    private var displayLink: CADisplayLink?
    private var timeObserver: Any?
     var eventSink: FlutterEventSink?

    init(registrar: FlutterPluginRegistrar) {
        self.textureRegistry = registrar.textures()
        super.init()
        self.textureId = textureRegistry.register(self)
    }
    
    /// Initialize the AVPlayer with a URL string
    func setUrl(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        // Clean up any existing player
        player?.pause()
        player = nil
        videoOutput = nil
        displayLink?.invalidate()
        displayLink = nil

        // Create new player item and output
        let asset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        let attrs: [String: Any] = [kCVPixelBufferPixelFormatTypeKey as String:
                                   kCVPixelFormatType_32BGRA]
        videoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: attrs)
        item.add(videoOutput!)
        
        // Create player
        player = AVPlayer(playerItem: item)
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        // Observe when ready to play
        item.addObserver(self, forKeyPath: "status", options: .initial, context: nil)
        
        // Notify Flutter on periodic time
        let interval = CMTime(value: 1, timescale: 2)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self, let current = self.player?.currentItem else { return }
            let posMs: Int
            if time.isNumeric {
                posMs = Int(CMTimeGetSeconds(time) * 1000)
            } else {
                posMs = 0
            }

            var durMs = 0
            if let d = self.player?.currentItem?.duration, d.isNumeric {
                durMs = Int(CMTimeGetSeconds(d) * 1000)
            }

            self.eventSink?(["id": self.textureId, "type": "position", "position": posMs, "duration": durMs])

        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(itemDidEnd(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: item)
    }
    
    /// Observe when AVPlayerItem is ready to play
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "status",
           let item = object as? AVPlayerItem,
           item.status == .readyToPlay {
            player?.play()
            displayLink = CADisplayLink(target: self, selector: #selector(onDisplayLink(_:)))
            displayLink?.add(to: .main, forMode: .common)
            displayLink?.isPaused = false
            item.removeObserver(self, forKeyPath: "status")
        }
    }
    
    @objc private func onDisplayLink(_ link: CADisplayLink) {
        textureRegistry.textureFrameAvailable(textureId)
    }
    
    func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        guard let output = videoOutput else { return nil }
        let itemTime = output.itemTime(forHostTime: CACurrentMediaTime())
        guard output.hasNewPixelBuffer(forItemTime: itemTime),
              let buffer = output.copyPixelBuffer(forItemTime: itemTime, itemTimeForDisplay: nil)
        else {
            return nil
        }
        // Return retained buffer for Flutter to render
        return Unmanaged.passRetained(buffer)
    }
    
    // MARK: - Event Stream (for sending events)
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        // Start sending events
        self.eventSink = events
        return nil
    }
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    @objc private func itemDidEnd(_ notification: Notification) {
        // Send playback completed event
        eventSink?(["id": textureId, "type": "state", "isPlaying": false])
    }
    
    /// Cleanup resources and unregister texture
    func dispose() {
        if let obs = timeObserver {
            player?.removeTimeObserver(obs)
            timeObserver = nil
        }
        player?.pause()
        displayLink?.invalidate()
        displayLink = nil
        NotificationCenter.default.removeObserver(self)
        textureRegistry.unregisterTexture(textureId)
    }
}

