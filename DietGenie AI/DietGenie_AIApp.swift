//
//  DietGenie_AIApp.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI
import FirebaseCore

@main
struct DietGenie_AIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
