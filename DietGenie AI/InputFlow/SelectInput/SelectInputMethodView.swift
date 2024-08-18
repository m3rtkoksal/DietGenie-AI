//
//  SelectInputMethodView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SelectInputMethodView: View {
    @EnvironmentObject var userInputModel: UserInputModel
    @StateObject private var viewModel = SelectInputMethodVM()
    @StateObject private var healthKitManager = HealthKitManager()
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var showAlert = false
    @State private var showLimitAlert = false
    @State private var showNoPlanAlert = false
    @State private var alertMessage = ""
    private let db = Firestore.firestore()
    
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .black,
                 showIndicator: $viewModel.showIndicator
        ) {
            NavigationLink(
                destination: GenderInputView()
                    .environmentObject(userInputModel),
                isActive: $viewModel.goToGenderInputPage
            ) {}
            NavigationLink(
                destination: PurposeInputView()
                    .environmentObject(userInputModel),
                isActive: $viewModel.goToPurposeInputPage
            ) {}
            NavigationLink(
                destination: SavedPlanView()
                    .environmentObject(userInputModel),
                isActive: $viewModel.goToSavedPlan
            ) {}
            VStack(spacing: 50) {
                CUIButton(text: "Create Program with HealthKit") {
                    if healthKitManager.isAuthorized {
                        checkIfDietPlanExists { exists, dietPlanData in
                            if exists {
                                // Handle the case where a diet plan already exists
                                self.showLimitAlert = true
                                self.alertMessage = "You need a premium account to be able to get another diet plan"
                                print("Diet plan exists.")
                            } else {
                                // Handle the case where no diet plan exists
                                fetchAndNavigate()
                                print("No diet plan exists.")
                            }
                        }
                        
                    }
                }
                CUIButton(text: "Enter Manually") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.viewModel.goToGenderInputPage = true
                    }
                }
                
                CUIButton(text: "Saved Diet Plan") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        checkIfDietPlanExists { exists, dietPlanData in
                            if exists, let data = dietPlanData {
                                // Pass the data to SavedPlanView
                                self.userInputModel.dietPlanData = data
                                self.viewModel.goToSavedPlan = true
                                print("Diet plan exists.")
                            } else {
                                // Handle the case where no diet plan exists
                                self.showNoPlanAlert = true
                                self.alertMessage = "You don't have a saved diet plan"
                                print("No diet plan exists.")
                            }
                        }
                    }
                }
            }
            .onDisappear {
                viewModel.showIndicator = false
            }
            .onAppear {
                healthKitManager.requestAuthorization()
                checkHealthKitAuthorization()
            }
        }
        .navigationBarTitle("DietGenie AI")
        .navigationBarItems(
            trailing: LogoutButton()
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Authorization Required"),
                message: Text(alertMessage),
                primaryButton: .default(Text("Allow")) {
                    if !healthKitManager.isAuthorized {
                        healthKitManager.requestAuthorization()
                    }
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
        .alert(isPresented: $showLimitAlert) {
            Alert(
                title: Text("Premium Account Needed"),
                message: Text(alertMessage),
                primaryButton: .default(Text("Subscribe")) {
                    
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
        alert(isPresented: $showNoPlanAlert) {
            Alert(
                title: Text("No Diet Plan"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                }
            )
        }
        
    }
    private func fetchAndNavigate() {
        healthKitManager.fetchYearlyData { activeEnergyData, restingEnergyData, bodyFatPercentageData, leanBodyMassData, weightData, genderData, heightData, ageData  in
            let daysInYear = 365.0
            let dailyActiveEnergy = (activeEnergyData ?? 0.0) / daysInYear
            let dailyRestingEnergy = (restingEnergyData ?? 0.0) / daysInYear
            self.userInputModel.activeEnergy = dailyActiveEnergy
            self.userInputModel.restingEnergy = dailyRestingEnergy
            self.userInputModel.bodyFatPercentage = bodyFatPercentageData
            self.userInputModel.leanBodyMass = leanBodyMassData
            self.userInputModel.weight = weightData
            self.userInputModel.height = heightData
            self.userInputModel.gender = genderData
            self.userInputModel.age = ageData
            // Ensure navigation only happens after data is fetched
            self.viewModel.goToPurposeInputPage = true
        }
    }
    private func checkHealthKitAuthorization() {
        // Perform the authorization check after a brief delay to allow isAuthorized to update
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !self.healthKitManager.isAuthorized {
                self.alertMessage = "HealthKit authorization is required to proceed. Please allow access in your device settings."
                self.showAlert = true
            }
        }
    }
    private func checkIfDietPlanExists(completion: @escaping (Bool, DietPlan?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false, nil)
            return
        }

        db.collection("dietPlans")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error checking diet plan: \(error.localizedDescription)")
                    completion(false, nil)
                } else if let snapshot = snapshot, !snapshot.isEmpty {
                    // Diet plan exists
                    if let document = snapshot.documents.first {
                        let data = document.data()
                        
                        // Decode the document fields
                        guard let meals = data["meals"] as? [String],
                              let userId = data["userId"] as? String else {
                            print("Error: Missing expected fields in diet plan document")
                            completion(false, nil)
                            return
                        }
                        
                        // Optionally decode createdAt if it's stored as a Timestamp
                        let createdAt = (data["createdAt"] as? Timestamp)?.dateValue()
                        
                        let dietPlan = DietPlan(id: document.documentID, createdAt: createdAt, meals: meals, userId: userId)
                        completion(true, dietPlan)
                    } else {
                        completion(false, nil)
                    }
                } else {
                    // No diet plan found
                    completion(false, nil)
                }
            }
    }

}

#Preview {
    SelectInputMethodView()
}
