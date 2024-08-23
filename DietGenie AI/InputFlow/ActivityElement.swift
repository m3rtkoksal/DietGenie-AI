//
//  ActivityElement.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 22.08.2024.
//

import SwiftUI

struct ActivityElement: View {
    var title: String
    var subtitle: String
    var isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .foregroundStyle(.black)
                    .font(.montserrat(.bold, size: 22))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(subtitle)
                    .foregroundStyle(Color.otherGray)
                    .font(.montserrat(.medium, size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        .padding()
        .background(isSelected ? Color.cellBGGreen : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 38))
        .overlay(
            RoundedRectangle(cornerRadius: 38)
                .stroke(isSelected ? Color.black : Color.progressBarPassive, lineWidth: 1)
        )
        .shadow(color: Color(red: 0.51, green: 0.74, blue: 0.62, opacity: 0.3), radius: 20, x: 0, y: 0)
        .padding()
        .padding(.horizontal, 33)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: -10) {
            ActivityElement(title: "Not very active", subtitle: "Spend most of the day sitting (e.g. desk job, bank teller) ", isSelected: true)
            ActivityElement(title: "Not very active", subtitle: "Spend most of the day sitting (e.g. desk job, bank teller) ", isSelected: true)
            ActivityElement(title: "Not very active", subtitle: "Spend most of the day sitting (e.g. desk job, bank teller) ", isSelected: true)
        }
    }
}
