//
//  ContentView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userInputModel = UserInputModel()
    @State private var isShowingWelcomeView = true
    var body: some View {
        if AuthenticationManager.shared.isLoggedIn {
            NavigationView {
                SelectInputMethodView()
                    .environmentObject(userInputModel)
            }
        } else {
            WelcomeView()
                .environmentObject(userInputModel)
        }
    }
}
