//
//  PurposeElement.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 23.08.2024.
//

import SwiftUI

struct PurposeElement: View {
    var title: String
    var icon: String
    var isSelected: Bool
    
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 38)
                    .stroke(isSelected ? Color.black : Color.progressBarPassive, lineWidth: 1)
                    .background(isSelected ? Color.cellBGGreen : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 38))
                    
                HStack {
                    Text(title)
                        .foregroundStyle(.black)
                        .font(.montserrat(.semiBold, size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Image(icon)
                        .resizable()
                        .frame(width: 38, height: 38)
                }
                .padding(.horizontal)
            }
            .frame(height: 46)
            .padding(.horizontal, 33)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: -10) {
            PurposeElement(title: "Not very active", icon: "loseWeight", isSelected: true)
            PurposeElement(title: "Not very active", icon: "gainFat", isSelected: false)
            PurposeElement(title: "Not very active", icon: "male", isSelected: false)
        }
    }
}
