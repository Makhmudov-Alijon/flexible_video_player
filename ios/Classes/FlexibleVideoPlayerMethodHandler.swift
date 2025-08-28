////
////  FlexibleVideoPlayerMethodHandler.swift
////  Pods
////
////  Created by Alijon Makhmudov on 28/08/25.
////
//
//
//import Flutter
//import Foundation
//
//
//public class FlexibleVideoPlayerMethodHandler: NSObject {
//    private weak var registrar: FlutterPluginRegistrar?
//    private var messenger: FlutterBinaryMessenger
//    // Map of textureId -> NativeVideoTexture
//    private var textures: [Int64: NativeVideoTexture] = [:]
//    
//    
//    public init(messenger: FlutterBinaryMessenger, registrar: FlutterPluginRegistrar) {
//        self.messenger = messenger
//        self.registrar = registrar
//        super.init()
//    }
//    
//    
//    // Primary entry point for method calls
//    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//        let method = call.method
//        switch method {
//        case "getPlatformVersion":
//            result("iOS " + UIDevice.current.systemVersion)
//            
//            
//        case "create":
//            createTexture(call: call, result: result)
//            
//            
//        case "dispose":
//            disposeTexture(call: call, result: result)
//            
//            
//        default:
//            let args = call.arguments as? [String: Any]
//            var targetId: Int64?
//            if let idNum = args?["textureId"] as? Int64 { targetId = idNum }
//            else if let idNum = args?["id"] as? Int64 { targetId = idNum }
//            else if let idNum = args?["textureId"] as? NSNumber { targetId = idNum.int64Value }
//            else if let idNum = args?["id"] as? NSNumber { targetId = idNum.int64Value }
//            
//            
//            if let tid = targetId, let texture = textures[tid] {
//                texture.handle(call: call, result: result)
//            } else {
//                // If there is exactly one texture, forward to it for convenience
//                if textures.count == 1, let texture = textures.values.first {
//                    texture.handle(call: call, result: result)
//                } else {
//                    result(FlutterMethodNotImplemented)
//                }
//            }
//        }
//    }
//    
//    private func createTexture(call: FlutterMethodCall, result: @escaping FlutterResult) {
//        guard let registrar = registrar else {
//            result(FlutterError(code: "registrar_missing", message: "Registrar not available", details: nil))
//            return
//        }
//        
//        
//        let texture = NativeVideoTexture(messenger: messenger, registrar: registrar)
//        // Register texture and keep its id
//        let textureId = registrar.textures().register(texture)
//        texture.textureId = textureId
////        texture.setupChannels() // set up event channel for this texture
//        
//        
//        textures[textureId] = texture
//        result(textureId)
//    }
//    
//    
//    private func disposeTexture(call: FlutterMethodCall, result: @escaping FlutterResult) {
//        // Accept either a map with textureId or a plain number
//        var textureIdArg: Int64?
//        if let args = call.arguments as? [String: Any] {
//            if let n = args["textureId"] as? Int64 { textureIdArg = n }
//            else if let n = args["textureId"] as? NSNumber { textureIdArg = n.int64Value }
//            else if let n = args["id"] as? Int64 { textureIdArg = n }
//            else if let n = args["id"] as? NSNumber { textureIdArg = n.int64Value }
//        } else if let n = call.arguments as? Int64 {
//            textureIdArg = n
//        } else if let n = call.arguments as? NSNumber {
//            textureIdArg = n.int64Value
//        }
//        
//        
//        // If no id provided and only one texture exists, dispose that one (convenience)
//        if textureIdArg == nil && textures.count == 1 {
//            textureIdArg = textures.keys.first
//        }
//        
//        
//        guard let tid = textureIdArg else {
//            result(FlutterError(code: "missing_texture_id", message: "No texture id provided and multiple textures exist", details: nil))
//            return
//        }
//        
//        
//        guard let texture = textures[tid] else {
//            result(FlutterError(code: "not_found", message: "Texture not found for id \(tid)", details: nil))
//            return
//        }
//        
//        
//        texture.dispose()
//        textures.removeValue(forKey: tid)
//        
//        
//        // Unregister texture from Flutter (safe to call if texture was registered)
//        if let registrar = registrar {
//            registrar.textures().unregisterTexture(tid)
//        }
//        
//        
//        result(nil)
//    }
//    
//}
