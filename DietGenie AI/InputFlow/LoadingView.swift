//
//  LoadingView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 24.08.2024.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct LoadingView: View {
    @EnvironmentObject var userInputModel: UserInputModel
    @StateObject private var viewModel = BaseViewModel()
    @StateObject private var healthKitManager = HealthKitManager()
    @StateObject private var openAIManager = OpenAIManager()
    @State private var goToDietProgram: Bool = false
    @State private var dietPlan: String? = nil
    @State var meals: [String] = []
    private let db = Firestore.firestore()
    
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .lightTeal,
                 showIndicator: $viewModel.showIndicator) {
            NavigationLink(
                destination: DietProgramView()
                    .environmentObject(userInputModel),
                isActive: $goToDietProgram
            ) {}
            VStack {
                CUILeftHeadline(
                    title: "Creating your diet plan",
                    subtitle: " Customizing your experience...  \n\n Analyzing your health data... \n\n Adding your goal... \n\n",
                    style: .black
                )
                LottieView(lottieFile: "", loopMode: .loop)
            }
            .onAppear {
                generateDietPlan()
            }
        }
                 .navigationTitle("")
                 .navigationBarBackButtonHidden()
    }
    
    private func generateDietPlan() {
        print("Generating diet plan...")
        
        // Create a DietPlan instance
        let dietPlan = DietPlan(
            id: nil, // Will be set by Firestore if it’s a new document
            createdAt: Date(),
            meals: [], // You can initialize with an empty array or a default value
            userId: userInputModel.userId ?? "unknown"
        )
        
        // Save the diet plan entry
        openAIManager.saveDietPlanEntry(userInputModel: userInputModel, dietPlan: dietPlan) {
            // Assuming saveDietPlanEntry is updated to include a completion handler
            print("Diet plan entry saved successfully.")
        }

        // Generate the diet plan
        openAIManager.generatePrompt(userInputModel: userInputModel) { responseMeals in
            DispatchQueue.main.async {
                print("Received response.")
                if let responseMeals = responseMeals {
                    self.meals = responseMeals
                    print("Updated meals: \(self.meals)")
                    saveDietPlanToFirebase(meals: responseMeals)
                    let newDietPlan = DietPlan(id: nil, createdAt: Date(), meals: responseMeals, userId: userInputModel.userId ?? "")
                    userInputModel.dietPlans.append(newDietPlan)
                    print("userInputModel updated with new diet plan.")
                } else {
                    print("No response meals received.")
                }
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
                goToDietProgram = true
            }
        }
    }
}

#Preview {
    LoadingView()
}
