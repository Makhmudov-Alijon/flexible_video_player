import Flutter
import UIKit
import AVFoundation
import AVKit

public class FlexibleVideoPlayerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var registrar: FlutterPluginRegistrar
    private var players = [Int64: VideoPlayerTexture]()
    private var eventSink: FlutterEventSink?
    
    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flexible_video_player", binaryMessenger: registrar.messenger())
        let events = FlutterEventChannel(name: "flexible_video_player_event", binaryMessenger: registrar.messenger())
        let instance = FlexibleVideoPlayerPlugin(registrar: registrar)
        registrar.addMethodCallDelegate(instance, channel: channel)
        events.setStreamHandler(instance)
    }
    
    // Handle method channel calls from Dart
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = (call.arguments as? [String: Any]) ?? [:]
        switch call.method {
        case "create":
            // Create new player with URL
            let player = VideoPlayerTexture(registrar: registrar)
            players[player.textureId] = player
//            player.setUrl(url)
            // Return the textureId to Dart
            result(player.textureId)
        
        case "setUrl":
            if let id = args["textureId"] as? Int64,
               let url = args["url"] as? String, let player = players[id] {
                player.setUrl(url)
            }
            
        case "play":
            if let id = args["textureId"] as? Int64,let player = players[id] {
                player.player?.play()
            }
            result(nil)
            
        case "pause":
            if let id = args["textureId"] as? Int64, let player = players[id] {
                player.player?.pause()
            }
            result(nil)
            
        case "seekTo":
            if let id = args["textureId"] as? Int64,
               let position = args["position"] as? Int,
               let player = players[id] {
                let time = CMTimeMake(value: Int64(position), timescale: 1000)
                player.player?.seek(to: time)
            }
            result(nil)
            
        case "setVolume":
            if let id = args["textureId"] as? Int64,
               let vol = args["volume"] as? Double,
               let player = players[id] {
                player.player?.volume = Float(vol)
            }
            result(nil)
            
        case "getTracks":
            if let id = args["textureId"] as? Int64,
               let player = players[id] {
                // Example: list audio and text tracks
                var tracks: [String: Any] = [:]
                if let asset = player.player?.currentItem?.asset {
                    if let audioGroup = asset.mediaSelectionGroup(forMediaCharacteristic: .audible) {
                        var audioTracks: [[String: Any]] = []
                        for (idx, opt) in audioGroup.options.enumerated() {
                            var info: [String: Any] = [
                                "index": idx,
                                "label": opt.displayName,
                                "language": opt.locale?.languageCode ?? ""
                            ]
                            // Example: add URI if available (for HLS)
                            if let props = opt.propertyList() as? [String: Any],
                               let uri = props["URI"] as? String {
                                info["uri"] = uri
                            }
                            audioTracks.append(info)
                        }
                        tracks["audio"] = audioTracks
                    }
                    if let textGroup = asset.mediaSelectionGroup(forMediaCharacteristic: .legible) {
                        var textTracks: [[String: Any]] = []
                        for (idx, opt) in textGroup.options.enumerated() {
                            textTracks.append([
                                "index": idx,
                                "label": opt.displayName,
                                "language": opt.locale?.languageCode ?? ""
                            ])
                        }
                        tracks["text"] = textTracks
                    }
                    // (Video quality listing would require HLS master playlist parsing or AVAsset variants on iOS15+)
                }
                result(tracks)
            } else {
                result([String: Any]())
            }
            
        case "selectAudio":
            if let id = args["textureId"] as? Int64,
               let index = args["index"] as? Int,
               let player = players[id],
               let item = player.player?.currentItem,
               let group = item.asset.mediaSelectionGroup(forMediaCharacteristic: .audible),
               index >= 0, index < group.options.count {
                let option = group.options[index]
                item.select(option, in: group)
            }
            result(nil)
            
        case "selectText":
            if let id = args["textureId"] as? Int64,
               let index = args["index"] as? Int,
               let player = players[id],
               let item = player.player?.currentItem,
               let group = item.asset.mediaSelectionGroup(forMediaCharacteristic: .legible) {
                if index == -1 {
                    // Deselect subtitles
                    item.select(nil, in: group)
                } else if index >= 0 && index < group.options.count {
                    let option = group.options[index]
                    item.select(option, in: group)
                }
            }
            result(nil)
            
        case "dispose":
            if let id = args["textureId"] as? Int64, let player = players[id] {
                player.dispose()
                players.removeValue(forKey: id)
            }
            result(nil)
            
        // Orientation/PiP methods could be added here if needed
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // StreamHandler: capture the FlutterEventSink when Dart starts listening
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        // Link each player’s eventSink to the plugin’s eventSink
        for player in players.values {
            player.eventSink = events
        }
        return nil
    }
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        for player in players.values {
            player.eventSink = nil
        }
        return nil
    }
}
