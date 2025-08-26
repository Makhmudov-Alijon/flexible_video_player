import Flutter
import Foundation
import AVKit
import MediaPlayer
import AVFoundation

// MARK: - FlutterPlatformView implementation

class FlutterRoutePickerView: NSObject, FlutterPlatformView {
    private var _flutterRoutePickerView : UIView
    private var _delegate: FlutterRoutePickerDelegate?

    init(
        messenger: FlutterBinaryMessenger,
        viewId: Int64,
        arguments: Dictionary<String, Any>
    ) {
        // default view to a tiny placeholder
        _flutterRoutePickerView = UIView(frame: .init(x: 0, y: 0, width: 44, height: 44))
        super.init()

        if #available(iOS 11.0, *) {
            let tempView = AVRoutePickerView(frame: .init(x: 0.0, y: 0.0, width: 44.0, height: 44.0))

            if let tintColor = arguments["tintColor"] as? Dictionary<String, Any> {
                tempView.tintColor = FlutterRoutePickerView.mapToColor(tintColor)
            }
            if let activeTintColor = arguments["activeTintColor"] as? Dictionary<String, Any> {
                tempView.activeTintColor = FlutterRoutePickerView.mapToColor(activeTintColor)
            }
            if let backgroundColor = arguments["backgroundColor"] as? Dictionary<String, Any> {
                tempView.backgroundColor = FlutterRoutePickerView.mapToColor(backgroundColor)
            }

            if #available(iOS 13.0, *) {
                if let pv = arguments["prioritizesVideoDevices"] as? Bool {
                    tempView.prioritizesVideoDevices = pv
                }
            }

            // Keep delegate strongly referenced
            _delegate = FlutterRoutePickerDelegate(viewId: viewId, messenger: messenger)
            tempView.delegate = _delegate

            _flutterRoutePickerView = tempView
        } else {
            let tempView = MPVolumeView(frame: .init(x: 0.0, y: 0.0, width: 44.0, height: 44.0))
            tempView.showsVolumeSlider = false
            _flutterRoutePickerView = tempView
        }
    }

    func view() -> UIView {
        return _flutterRoutePickerView
    }

    static func mapToColor(_ map: Dictionary<String, Any>) -> UIColor {
        // Accept Int or Double for color components.
        func component(_ key: String) -> CGFloat {
            if let i = map[key] as? Int { return CGFloat(i) / 255.0 }
            if let d = map[key] as? Double { return CGFloat(d) / 255.0 }
            if let f = map[key] as? CGFloat { return f / 255.0 }
            return 0.0
        }
        let aRaw = map["alpha"]
        var alpha: CGFloat = 1.0
        if let i = aRaw as? Int { alpha = CGFloat(i) / 255.0 }
        else if let d = aRaw as? Double { alpha = CGFloat(d) / 255.0 }
        else if let f = aRaw as? CGFloat { alpha = f / 255.0 }
        return UIColor(
            red: component("red"),
            green: component("green"),
            blue: component("blue"),
            alpha: alpha
        )
    }
}

// MARK: - Delegate that listens for route changes, interruptions, and AirPlay availability

class FlutterRoutePickerDelegate : NSObject, AVRoutePickerViewDelegate {
    private let _methodChannel: FlutterMethodChannel

    // AVRouteDetector for availability (iOS 13+)
    private var routeDetector: AVRouteDetector?
    private var routeDetectorTimer: Timer?
    private var lastKnownAvailability: Bool = false
    private var lastKnownConnection: Bool = false

    init(viewId: Int64, messenger: FlutterBinaryMessenger) {
        _methodChannel = FlutterMethodChannel(name: "flutter_to_airplay#\(viewId)", binaryMessenger: messenger)
        super.init()

        // Observe AVAudioSession route changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRouteChange(_:)),
            name: AVAudioSession.routeChangeNotification,
            object: nil
        )

        // Observe AVAudioSession interruptions (calls, etc.)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruption(_:)),
            name: AVAudioSession.interruptionNotification,
            object: nil
        )

        // Observe wireless route activity (AirPlay connect/disconnect)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleWirelessRouteActiveChange(_:)),
            name: Notification.Name("MPVolumeViewWirelessRouteActiveDidChangeNotification"),
            object: nil
        )

        // AVRouteDetector (iOS 13+). Use polling to avoid KVO issues across SDKs.
        if #available(iOS 13.0, *) {
            let detector = AVRouteDetector()
            detector.isRouteDetectionEnabled = true
            self.routeDetector = detector

            // Poll once per second for availability changes
            self.routeDetectorTimer = Timer.scheduledTimer(
                timeInterval: 1.0,
                target: self,
                selector: #selector(checkRouteDetection),
                userInfo: nil,
                repeats: true
            )
        }

        // Send initial status after initialization
        sendAirplayStatus()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        routeDetectorTimer?.invalidate()
        routeDetector?.isRouteDetectionEnabled = false
        routeDetector = nil
    }

    // MARK: - AVRoutePickerViewDelegate

    func routePickerViewWillBeginPresentingRoutes(_ routePickerView: AVRoutePickerView) {
        _methodChannel.invokeMethod("onShowPickerView", arguments: nil)
    }

    func routePickerViewDidEndPresentingRoutes(_ routePickerView: AVRoutePickerView) {
        _methodChannel.invokeMethod("onClosePickerView", arguments: nil)
    }

    // MARK: - Notifications

    @objc private func handleRouteChange(_ notification: Notification) {
        // route change may indicate connection/disconnection
        let isConnected = isAirPlayCurrentlyConnected()
        if isConnected != lastKnownConnection {
            lastKnownConnection = isConnected
            _methodChannel.invokeMethod("onAirplayConnectionChanged", arguments: ["isConnected": isConnected])
        }

        // Send the existing routeChanged payload (if you want)
        var reasonRaw: Int = -1
        if let userInfo = notification.userInfo,
           let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt {
            reasonRaw = Int(reasonValue)
        }

        let outputs = AVAudioSession.sharedInstance().currentRoute.outputs.map { output -> [String: String] in
            return [
                "portType": output.portType.rawValue,
                "portName": output.portName
            ]
        }

        let args: [String: Any] = [
            "reason": reasonRaw,
            "outputs": outputs
        ]

        _methodChannel.invokeMethod("onRouteChanged", arguments: args)
    }

    @objc private func handleInterruption(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let _ = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            _methodChannel.invokeMethod("onAudioInterruption", arguments: nil)
            return
        }

        var optionRaw: Int = 0
        if let optionValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
            optionRaw = Int(optionValue)
        }

        let args: [String: Any] = [
            "type": Int(typeValue),
            "option": optionRaw
        ]

        _methodChannel.invokeMethod("onAudioInterruption", arguments: args)
    }

    @objc private func handleWirelessRouteActiveChange(_ notification: Notification) {
        let isConnected = isAirPlayCurrentlyConnected()
        if isConnected != lastKnownConnection {
            lastKnownConnection = isConnected
            _methodChannel.invokeMethod("onAirplayConnectionChanged", arguments: ["isConnected": isConnected])
        }

        // legacy/compat event
        _methodChannel.invokeMethod("onWirelessRouteActiveChanged", arguments: ["isActive": isConnected])
    }

    // MARK: - Route detection polling (availability)

    @objc private func checkRouteDetection() {
        guard #available(iOS 13.0, *) else { return }
        let available = routeDetector?.isRouteDetectionEnabled ?? false
        if available != lastKnownAvailability {
            lastKnownAvailability = available
            _methodChannel.invokeMethod("onAirplayAvailabilityChanged", arguments: ["isAvailable": available])
        }
    }

    // Helper to determine if AirPlay is currently connected
    private func isAirPlayCurrentlyConnected() -> Bool {
        let outputs = AVAudioSession.sharedInstance().currentRoute.outputs
        return outputs.contains { output in
            if output.portType == .airPlay { return true }
            return output.portType.rawValue.lowercased().contains("airplay")
        }
    }

    // Send both statuses (initial)
    private func sendAirplayStatus() {
        let available: Bool
        if #available(iOS 13.0, *) {
            available = routeDetector?.isRouteDetectionEnabled ?? false
        } else {
            available = false
        }
        lastKnownAvailability = available

        let connected = isAirPlayCurrentlyConnected()
        lastKnownConnection = connected

        _methodChannel.invokeMethod("onAirplayAvailabilityChanged", arguments: ["isAvailable": available])
        _methodChannel.invokeMethod("onAirplayConnectionChanged", arguments: ["isConnected": connected])
    }
}

