//
//  MealCardElementView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 14.08.2024.
//

import SwiftUI

struct MealCardElementView: View {
    var meal: String

    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.teal, lineWidth: 2)
                Text(meal)
                    .foregroundStyle(.teal)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding() // Add padding only if necessary
            }
        }
        .background(Color.clear)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}



#Preview {
    MealCardElementView(meal: "Dolma")
}
