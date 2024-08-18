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
            Text("Sign out")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.teal)
                .padding(5)
        }
        .frame(width: 50)
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
