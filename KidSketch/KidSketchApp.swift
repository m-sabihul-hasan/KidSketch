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
    @State private var showLaunchScreen = false
    
    var body: some Scene {
        WindowGroup {
            if showLaunchScreen {
                LaunchScreenView()
                    .onAppear{
                        AppDelegate.lockOrientation(.landscape)
                        print("[HandwritingApp] Launched in landscape mode.")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                            showLaunchScreen = false
                        }
                    }
            }
            else {
                ContentView()
//                HomeView()
                    .onAppear {
                        AppDelegate.lockOrientation(.landscape)
                        print("[HandwritingApp] Launched in landscape mode.")
                        
                        
                    }
                
            }
        }
    }
}
