////
////  FullscreenVideoController.swift
////  Runner
////
////  Created by Alijon Makhmudov on 21/08/25.
////
//
//import UIKit
//
//final class OrientationController {
//    
//    static func forceLandscape() {
//        setOrientation(.landscapeRight)
//    }
//    
//    static func forcePortrait() {
//        setOrientation(.portrait)
//    }
//    
//    static func getOrientation() -> UIDeviceOrientation {
//        return UIDevice.current.orientation.self
//    }
//    
//    private static func setOrientation(_ orientation: UIInterfaceOrientation) {
//        DispatchQueue.main.async {
//            if #available(iOS 16.0, *) {
//                guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
//                let geometry = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: orientation == .portrait ? .portrait : .landscapeRight)
//                do {
//                    try scene.requestGeometryUpdate(geometry)
//                } catch {
//                    print("Failed to request geometry update: \\(error)")
//                }
//            } else {
//                // Fallback for iOS < 16
//                UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
//                UIViewController.attemptRotationToDeviceOrientation()
//            }
//        }
//    }
//}
