//
//  DietProgramView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct DietProgramView: View {
    @EnvironmentObject var userInputModel: UserInputModel
    @StateObject private var viewModel = DietProgramVM()
    @StateObject private var healthKitManager = HealthKitManager()
    @StateObject private var openAIManager = OpenAIManager()
    @State private var dietPlan: String? = nil
    @State var meals: [String] = []
    private let db = Firestore.firestore()
    @State private var selectedMeals: Set<String> = []
    
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .lightTeal,
                 showIndicator: $viewModel.showIndicator) {
            VStack {
                CUILeftHeadline(
                    title: "Your Daily Plan",
                    subtitle: "",
                    style: .black,
                    bottomPadding: 50)
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Array(meals.enumerated()), id: \.offset) { index, meal in
                            let icon = viewModel.mealIcons[index % viewModel.mealIcons.count]
                            MealCardElementView(meal: meal, icon: icon, selectedMeals: selectedMeals)
                                .onTapGesture {
                                    if selectedMeals.contains(meal) {
                                        selectedMeals.remove(meal)
                                    } else {
                                        selectedMeals.insert(meal)
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .onAppear {
                fetchDietPlan()
                viewModel.getMealIcons()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private func fetchDietPlan() {
        // Fetch meals directly as strings from userInputModel
        meals = userInputModel.dietPlans.first?.meals ?? []

        if meals.isEmpty {
            print("No meals found in userInputModel.")
        } else {
            print("Diet plan fetched from userInputModel. Meals: \(meals)")
        }
    }

}
