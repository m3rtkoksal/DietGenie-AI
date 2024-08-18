//
//  DietProgramView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

struct DietProgramView: View {
    @EnvironmentObject var userInputModel: UserInputModel
    @StateObject private var viewModel = DietProgramVM()
    @StateObject private var healthKitManager = HealthKitManager()
    @StateObject private var openAIManager = OpenAIManager()
    @State private var dietPlan: String? = nil
    @State var meals: [String] = []
    
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .black,
                 showIndicator: $viewModel.showIndicator) {
            VStack {
                CUILeftHeadline(
                    title: "Your Daily Plan",
                    subtitle: "",
                    style: .red,
                    bottomPadding: 20)
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(meals, id: \.self) { meal in
                            MealCardElementView(meal: meal)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            .onAppear {
                generateDietPlan()
            }
        }
                 
                 .navigationBarTitle("DietGenie AI")
                 .navigationBarBackButtonHidden()
                 .navigationBarItems(
                    leading:
                        CUIBackButton()
                 )
        
    }
    private func generateDietPlan() {
        viewModel.showIndicator = true // Show indicator
        print("Generating diet plan...")
        
        openAIManager.generatePrompt(userInputModel: userInputModel) { responseMeals in
            DispatchQueue.main.async {
                print("Received response.")
                if let responseMeals = responseMeals {
                    self.meals = responseMeals
                } else {
                    print("No response meals received.")
                }
                viewModel.showIndicator = false // Hide indicator
            }
        }
    }
}
