//
//  LogoutButton.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import SwiftUI
import FirebaseAuth

struct LogoutButton: View {
    var body: some View {
        Button {
            signOut()
        } label: {
            Text("Log out")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.red)
                .padding(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 38)
                        .strokeBorder(Color.lightGray200, lineWidth: 2)
                        .shadow(color: Color(red: 0.51, green: 0.74, blue: 0.62, opacity: 0.3), radius: 20, x: 0, y: 0)
                )
               
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            AuthenticationManager.shared.logOut()
            print("User signed out successfully!")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
