//
//  MealCardElementView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 14.08.2024.
//

import SwiftUI

struct MealCardElementView: View {
    var meal: String
    var icon: String
    var selectedMeals: Set<String>
    
    private var firstSentence: String {
        // Extract the first line from the meal text
        meal.split(separator: "\n").first.map(String.init) ?? ""
    }
    private var remainingText: String {
        // Extract the remaining text after the first line
        let components = meal.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: false)
        return components.count > 1 ? String(components[1]) : ""
    }
    private var isSelected: Bool {
            selectedMeals.contains(meal)
        }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 30)
                .foregroundColor(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .overlay(
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .center) {
                            Image(icon)
                                .frame(width: 46, height: 46)
                            Text(firstSentence)
                                .font(.montserrat(.semiBold, size: 20))
                            Spacer()
                        }
                        .padding(.top, 10) 
                        Text(remainingText)
                            .foregroundColor(.black)
                            .font(.montserrat(.medium, size: 16))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        Spacer()
                    }
                        .padding(.leading)
                        .padding(.trailing, 40) // Ensure space for the top-right image
                )
                .overlay(
                    Image(isSelected ? "selectedMeal" : "deselectedMeal")
                    ,
                    alignment: .topTrailing // Position image at top-right corner
                )
                .padding(.horizontal)
                .padding(.vertical, 10)
        }
        .background(Color.clear)
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(height: Constant.imageHeight
               + CGFloat(CGFloat((remainingText.components(separatedBy: "\n").count + 1)) * Constant.mealItemLenght) 
               + Constant.bottomPadding )
    }
}

#Preview {
    MealCardElementView(meal: "Breakfast\n- 2 boiled eggs (140g)\n- 1 whole wheat toast (30g)\n- 1 medium avocado (200g)", icon: "falafel", selectedMeals: [])
}
