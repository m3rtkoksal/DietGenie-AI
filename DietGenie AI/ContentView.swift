//
//  ContentView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userInputModel = UserInputModel()

    var body: some View {
        NavigationView {
            WelcomeView()
                .environmentObject(userInputModel)
        }
    }
}
