//
//  DietGenie_AIApp.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck
import RevenueCat

@main
struct DietGenie_AIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var router = BindingRouter()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        setupRevenueCat()
        // Initialize AppCheck with DeviceCheck provider
        let providerFactory = DeviceCheckProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        return true
    }
    
    private func setupRevenueCat() {
        RemoteConfigManager.shared.fetchRevenueCatAPIKey { apiKey in
            if let key = apiKey {
                KeychainManager.shared.saveToKeychain(data: key, forKey: .revenueCatToken)
                Purchases.configure(withAPIKey: key)
                print("RevenueCat configured successfully.")
            } else {
                print("Failed to fetch RevenueCat API key.")
            }
        }
    }
}
