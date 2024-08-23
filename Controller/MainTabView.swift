//
//  MainTabView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
//            SelectInputMethodView()
//                .tabItem {
//                    Label("Home", systemImage: "house")
//                }

            SavedPlanView()
                .tabItem {
                    Label("Plans", systemImage: "list.dash")
                }

//            SettingsView()
//                .tabItem {
//                    Label("Settings", systemImage: "gear")
//                }
        }
        .accentColor(.teal) // Optional: Customize the selected tab color
    }
}
