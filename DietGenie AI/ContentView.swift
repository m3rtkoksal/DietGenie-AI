//
//  ContentView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import HealthKit

struct ContentView: View {
    @StateObject private var userInputModel = UserInputModel()
    @ObservedObject private var authManager = AuthenticationManager.shared
    @State private var shouldShowRoot = true
    
    var body: some View {
        ZStack {
            if authManager.isLoggedIn {
                NavigationStack {
                    MainTabView()
                        .environmentObject(userInputModel)
                        .onAppear {
                            fetchUserData()
                            fetchHealthData()
                        }
                }
            } else {
                OnboardingView()
                    .environmentObject(userInputModel)
            }
        }
    }
    
    private func fetchUserData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user ID found.")
            return
        }
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
            } else if let document = document, document.exists {
                let data = document.data()
                userInputModel.firstName = data?["name"] as? String ?? ""
                userInputModel.lastName = data?["surname"] as? String ?? ""
                userInputModel.email = data?["email"] as? String ?? ""
                // Continue updating other fields in userInputModel as necessary
            }
        }
    }
    
    private func fetchHealthData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user ID found.")
            return
        }
            let db = Firestore.firestore()

            db.collection("users").document(userId).collection("healthData").order(by: "timestamp", descending: true).limit(to: 1).getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching health data: \(error.localizedDescription)")
                } else if let document = querySnapshot?.documents.first {
                    let data = document.data()
                    if let activeEnergy = data["activeEnergyBurned"] as? Double {
                        userInputModel.activeEnergy = activeEnergy
                    }
                    if let restingEnergy = data["restingEnergyBurned"] as? Double {
                        userInputModel.restingEnergy = restingEnergy
                    }
                    if let bodyFatPercentage = data["bodyFatPercentage"] as? Double {
                        userInputModel.bodyFatPercentage = bodyFatPercentage
                    }
                    if let leanBodyMass = data["leanBodyMass"] as? Double {
                        userInputModel.leanBodyMass = leanBodyMass
                    }
                    if let weight = data["weight"] as? Double {
                        userInputModel.weight = weight
                    }
                    if let height = data["height"] as? Double {
                                    userInputModel.height = height
                                }
                    if let genderString = data["gender"] as? String {
                        userInputModel.gender = genderStringToHKBiologicalSex(genderString)
                    }
                    if let birthday = data["birthday"] as? String {
                        userInputModel.birthday = birthday
                    }
                }
            }
        }
    
    func genderStringToHKBiologicalSex(_ gender: String) -> HKBiologicalSex? {
        switch gender.lowercased() {
        case "male":
            return .male
        case "female":
            return .female
        case "other":
            return .other
        default:
            return nil
        }
    }
}
