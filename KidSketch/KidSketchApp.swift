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
            ContentView()
                .onAppear {
                    AppDelegate.lockOrientation(.landscape)
                    print("[HandwritingApp] Launched in landscape mode.")

                }
        }
    }
}
