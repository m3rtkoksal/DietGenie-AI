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
                    saveDietPlanToFirebase(meals: responseMeals)
                } else {
                    print("No response meals received.")
                }
                viewModel.showIndicator = false // Hide indicator
            }
        }
    }
    private func saveDietPlanToFirebase(meals: [String]) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user ID found")
            return
        }
        
        let dietPlanData: [String: Any] = [
            "userId": userId,
            "createdAt": Timestamp(date: Date()),
            "meals": meals
        ]
        
        db.collection("dietPlans").addDocument(data: dietPlanData) { error in
            if let error = error {
                print("Error saving diet plan: \(error.localizedDescription)")
            } else {
                print("Diet plan saved successfully.")
            }
        }
    }
}
