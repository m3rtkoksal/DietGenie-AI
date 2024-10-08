//
//  DietPlanDetailView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct DietPlanDetailView: View {
    let dietPlan: DietPlan
    @StateObject private var viewModel = DietPlanDetailVM()
    @State private var selectedMeals: Set<String> = []
    private let mealManager = MealManager()

    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .lightTeal,
                 showIndicator: $viewModel.showIndicator
        ) {
            VStack {
                CUILeftHeadline(
                    title: "Your Saved Diet Plans",
                    subtitle: "",
                    style: .black)
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(dietPlan.meals.indices, id: \.self) { index in
                            let icon = viewModel.mealIcons.isEmpty ? "" : viewModel.mealIcons[index % viewModel.mealIcons.count]
                            MealCardElementView(meal: dietPlan.meals[index], icon: icon, selectedMeals: selectedMeals)
                                .onTapGesture {
                                    if selectedMeals.contains(dietPlan.meals[index]) {
                                        selectedMeals.remove(dietPlan.meals[index])
                                    } else {
                                        selectedMeals.insert(dietPlan.meals[index])
                                    }
                                }
                        }
                        .navigationBarBackButtonHidden()
                        .navigationBarItems(
                            leading:
                                CUIBackButton()
                        )
                    }
                }
            }
            .onAppear {
                MealManager.shared.checkAndCleanDaily() // Clean old data if needed
                viewModel.getMealIcons()
                if let dietPlanId = dietPlan.id, !dietPlanId.isEmpty {
                    // Load selected meals only once on appear
                    selectedMeals = MealManager.shared.loadSelectedMeals(dietPlanId: dietPlanId)
                } else {
                    print("Diet plan ID is invalid")
                }
            }
                
            .onDisappear {
                if let dietPlanId = dietPlan.id, !dietPlanId.isEmpty {
                    MealManager.shared.saveSelectedMeals(dietPlanId: dietPlanId, selectedMeals: selectedMeals)
                } else {
                    print("Diet plan ID is invalid")
                }
            }
        }
    }
}
