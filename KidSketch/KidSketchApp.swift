//
//  KidSketchApp.swift
//  KidSketch
//
//  Created by Muhammad Sabihul Hasan on 26/02/25.
//

import SwiftUI

@main
struct KidSketchApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            LetterDrawView()
//            LetterDrawingView(correctLetter: "A")
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    // This static variable will hold the orientation lock
    static var orientationLock: UIInterfaceOrientationMask = .all // Default: all orientations allowed

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    // Function to lock the orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        orientationLock = orientation
        
        // Manually trigger orientation update
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.windows.first?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }
    
    // Function to unlock the orientation
    static func unlockOrientation() {
        orientationLock = .all
        
        // Manually trigger orientation update
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.windows.first?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }
}
