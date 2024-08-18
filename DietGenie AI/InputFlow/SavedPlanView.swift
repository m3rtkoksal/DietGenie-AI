//
//  SavedPlanView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import SwiftUI

struct SavedPlanView: View {
    @EnvironmentObject var userInputModel: UserInputModel
    @StateObject private var viewModel = SelectInputMethodVM()
    @StateObject private var healthKitManager = HealthKitManager()
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .black,
                 showIndicator: $viewModel.showIndicator
        ) {
            if let dietPlan = userInputModel.dietPlanData {
                // Display the diet plan data
                VStack {
                    CUILeftHeadline(
                        title: "Your Saved Diet Plan",
                        subtitle: "",
                        style: .red,
                        bottomPadding: 50)
                    ScrollView {
                        if let createdAt = dietPlan.createdAt {
                            Text("Created At: \(createdAt, formatter: dateFormatter)")
                        } else {
                            Text("Created At: N/A")
                        }
                        // Display other properties of dietPlan as needed
                        ForEach(dietPlan.meals, id: \.self) { meal in
                            MealCardElementView(meal: meal)
                        }
                    }
                }
            } else {
                Text("No saved diet plan available.")
                    .padding()
            }
        }
        .navigationBarTitle("DietGenie AI")
        .navigationBarBackButtonHidden()
        .navigationBarItems(
           leading:
               CUIBackButton()
        )
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()
