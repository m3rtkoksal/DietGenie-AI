//
//  SelectInputMethodView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

enum AlertType: Identifiable {
    case authorizationRequired
    case premiumAccountNeeded
    case noDietPlan
    
    var id: UUID {
        switch self {
        case .authorizationRequired:
            return UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
        case .premiumAccountNeeded:
            return UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
        case .noDietPlan:
            return UUID(uuidString: "00000000-0000-0000-0000-000000000003")!
        }
    }
}

struct SelectInputMethodView: View {
    @EnvironmentObject var userInputModel: UserInputModel
    @StateObject private var viewModel = SelectInputMethodVM()
    @StateObject private var healthKitManager = HealthKitManager()
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var activeAlert: AlertType?
    
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
                                print("Diet plan exists.")
                                activeAlert = .premiumAccountNeeded
                            } else {
                                // Handle the case where no diet plan exists
                                fetchAndNavigate()
                                print("No diet plan exists.")
                            }
                        }
                    } else {
                        activeAlert = .authorizationRequired
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
                                // Add the diet plan to the list
                                if let index = self.userInputModel.dietPlans.firstIndex(where: { $0.id == data.id }) {
                                    self.userInputModel.dietPlans[index] = data
                                } else {
                                    self.userInputModel.dietPlans.append(data)
                                }
                                self.viewModel.goToSavedPlan = true
                                print("Diet plan exists.")
                            } else {
                                // Handle the case where no diet plan exists
                                activeAlert = .noDietPlan
                                print("No diet plan exists.")
                            }
                        }
                    }
                }
                LogoutButton()
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
        
        .alert(item: $activeAlert) { alertType in
            switch alertType {
            case .authorizationRequired:
                return Alert(
                    title: Text("Authorization Required"),
                    message: Text("You need to authorize access."),
                    primaryButton: .default(Text("Allow")) {
                        // Handle authorization
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            case .premiumAccountNeeded:
                return Alert(
                    title: Text("Premium Account Needed"),
                    message: Text("You need a premium account to access this feature."),
                    primaryButton: .default(Text("Subscribe")) {
                        // Handle subscription
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            case .noDietPlan:
                return Alert(
                    title: Text("No Diet Plan"),
                    message: Text("You don't have a saved diet plan."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func fetchAndNavigate() {
        // Replace "yourUserId" with the actual user ID
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        healthKitManager.fetchYearlyData(userId: userId) { (activeEnergyData, restingEnergyData, bodyFatPercentageData, leanBodyMassData, weightData, genderData, heightData, ageData) in
            // Calculate daily values
            let daysInYear = 365.0
            let dailyActiveEnergy = (activeEnergyData ?? 0.0) / daysInYear
            let dailyRestingEnergy = (restingEnergyData ?? 0.0) / daysInYear
            
            // Update user input model
            self.userInputModel.activeEnergy = dailyActiveEnergy
            self.userInputModel.restingEnergy = dailyRestingEnergy
            self.userInputModel.bodyFatPercentage = bodyFatPercentageData
            self.userInputModel.leanBodyMass = leanBodyMassData
            self.userInputModel.weight = weightData
            self.userInputModel.height = heightData
            self.userInputModel.gender = genderData
            self.userInputModel.age = ageData
            
            // Ensure navigation only happens after data is fetched and saved
            self.viewModel.goToPurposeInputPage = true
        }
    }

    private func checkHealthKitAuthorization() {
        // Perform the authorization check after a brief delay to allow isAuthorized to update
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !self.healthKitManager.isAuthorized {
                activeAlert = .authorizationRequired
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
                        
                        // Create DietPlan instance
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
