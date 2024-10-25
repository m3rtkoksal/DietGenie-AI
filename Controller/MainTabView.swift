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
            SavedPlanView()
                .tabItem {
                    Label("Plans", systemImage: "list.dash")
                }
                .navigationBarHidden(true)
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .navigationBarHidden(true)
            OfferingsView()
                .tabItem {
                    Label("Offers", systemImage: "command")
                }
        }
        .accentColor(Color.topGreen) // Optional: Customize the selected tab color
    }
}
