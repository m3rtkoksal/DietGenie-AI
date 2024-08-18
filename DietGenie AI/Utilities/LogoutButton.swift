//
//  LogoutButton.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import SwiftUI

struct LogoutButton: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var router: BindingRouter
    var body: some View {
        Button {
            router.popToRoot()
        } label: {
            Text("Sign out")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.teal)
                .padding(5)
        }
        .frame(width: 50)
    }
}
