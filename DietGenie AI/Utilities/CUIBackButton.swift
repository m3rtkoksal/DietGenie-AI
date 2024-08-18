//
//  CUIBackButton.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

struct CUIBackButton: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var router: BindingRouter
    var toRoot = false
    var body: some View {
        Button {
            if toRoot {
                router.popToRoot()
            } else {
                self.presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Image(systemName: "chevron.backward")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.teal)
                .padding(5)
        }
        .frame(width: 50)
    }
}
