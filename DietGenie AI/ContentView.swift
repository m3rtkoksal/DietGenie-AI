//
//  ContentView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userInputModel = UserInputModel()
    @ObservedObject private var authManager = AuthenticationManager.shared
    @State private var shouldShowRoot = true
    
    var body: some View {
        ZStack {
            if authManager.isLoggedIn {
                NavigationView {
                    MainTabView()
                        .environmentObject(userInputModel)
                    SelectInputMethodView()
                        .environmentObject(userInputModel)
                }
            } else {
                WelcomeView()
                    .environmentObject(userInputModel)
            }
        }
    }
}
