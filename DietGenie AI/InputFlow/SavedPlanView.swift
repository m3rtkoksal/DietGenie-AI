//
//  SavedPlanView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

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
            VStack {
                CUILeftHeadline(
                    title: "Your Saved Diet Plans",
                    subtitle: "You can see details of your previous meal plans from this list",
                    style: .red,
                    bottomPadding: 50)
                ForEach(userInputModel.dietPlans) { dietPlan in
                    NavigationLink(destination: DietPlanDetailView(dietPlan: dietPlan)) {
                        ScrollView {
                            VStack(alignment: .leading) {
                                DietPlanElement(date: dietPlan.createdAt?.getShortDate() ?? "N/A")
                                    .padding(.top)
                            }
                        }
                    }
                }
            }
            .onAppear {
                // Fetch diet plans or update the list if necessary
                fetchDietPlans()
            }
        }
        .navigationBarTitle("DietGenie AI")
        .navigationBarBackButtonHidden()
        .navigationBarItems(
            leading:
                CUIBackButton()
        )
    }
    private func fetchDietPlans() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("dietPlans")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching diet plans: \(error.localizedDescription)")
                } else {
                    var fetchedDietPlans: [DietPlan] = []
                    for document in querySnapshot!.documents {
                        do {
                            let dietPlan = try document.data(as: DietPlan.self)
                            fetchedDietPlans.append(dietPlan)
                        } catch {
                            print("Error decoding diet plan: \(error.localizedDescription)")
                        }
                    }
                    // Update userInputModel.dietPlans on the main thread
                    DispatchQueue.main.async {
                        self.userInputModel.dietPlans = fetchedDietPlans
                    }
                }
            }
    }
}
