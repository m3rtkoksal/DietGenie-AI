//
//  CUIDismissButton.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 21.08.2024.
//

import SwiftUI

struct CUIDismissButton: View {
    @Environment(\.dismiss) private var dismiss
    var toRoot = false
    
    var body: some View {
        Button {
            NavigationUtil.popToRootView()
        } label: {
            Image(systemName: "xmark")
                .foregroundColor(.black)
                .padding(.leading, 16)
        }
    }
}
