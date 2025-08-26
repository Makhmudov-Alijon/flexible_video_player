import Flutter
import UIKit

public class FlexibleVideoPlayerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flexible_video_player", binaryMessenger: registrar.messenger())
    let instance = FlexibleVideoPlayerPlugin()
    let factory = NativeVideoFactory(messenger: registrar.messenger())
    let factoryAirPlay = AirPlayViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "flexible_video_view")
    registrar.register(factoryAirPlay, withId: "flutter_to_airplay")
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
