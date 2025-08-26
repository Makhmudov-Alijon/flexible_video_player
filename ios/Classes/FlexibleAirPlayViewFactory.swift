//
//  AirPlayViewFactory.swift
//  Runner
//
//  Created by Alijon Makhmudov on 20/08/25.
//

import Flutter
import UIKit

public class AirPlayViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    public init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let argumens = args as! Dictionary<String, Any>;
        return FlutterRoutePickerView(messenger: messenger, viewId: viewId, arguments: argumens)
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
