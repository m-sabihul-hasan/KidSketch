//
//  AppDelegate.swift
//  KidSketch
//
//  Created by Muhammad Sabihul Hasan on 13/03/25.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock: UIInterfaceOrientationMask = .landscape

    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask = .landscape) {
        orientationLock = orientation
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.windows.first?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
        print("[AppDelegate] Orientation locked to \(orientation).")
    }
}
