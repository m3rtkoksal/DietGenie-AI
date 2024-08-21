//
//  HealthKitPermissionVM.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 21.08.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Combine

class HealthKitPermissionVM: BaseViewModel {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userInputModel: UserInputModel
    @StateObject private var healthKitManager = HealthKitManager()
    @Published var goToBMIInputPage = false
    @Published var menuPickerItems:[CUIDropdownItemModel] = []
    @Published var goToHealthPermission = false
    @Published var goToLogin = false
    @Published var goToPrivacyPolicy = false
    private let db = Firestore.firestore()
    
    func fetchMenuItems() {
        self.menuPickerItems = [
            CUIDropdownItemModel(id: "0", icon: "male", text: "Male", hasArrow: false),
            CUIDropdownItemModel(id: "1", icon: "female", text: "Female", hasArrow: false)
        ]
    }
    
    func fetchHealthData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user ID found.")
            return
        }
        
        healthKitManager.fetchYearlyData(userId: userId) { activeEnergyData, restingEnergyData, bodyFatPercentageData, leanBodyMassData, weightData, genderData, heightData, ageData in
            self.userInputModel.userId = userId
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
        }
    }
    
    func saveHealthToFireStore() {
        if healthKitManager.isAuthorized {
            // Fetch health data once
            self.fetchHealthData()
            
            // Save to Firestore once data has been fetched
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Delay to ensure fetch completion
                guard let userId = Auth.auth().currentUser?.uid else {
                    print("No user ID found.")
                    return
                }
                self.healthKitManager.saveHealthDataToFirestore(
                    userId: userId,
                    activeEnergy: self.userInputModel.activeEnergy,
                    restingEnergy: self.userInputModel.restingEnergy,
                    bodyFatPercentage: self.userInputModel.bodyFatPercentage,
                    leanBodyMass: self.userInputModel.leanBodyMass,
                    weight: self.userInputModel.weight,
                    gender: self.userInputModel.gender,
                    height: self.userInputModel.height,
                    age: self.userInputModel.age
                ) {
                    print("Health data saved successfully.")
                }
            }
        }
    }
}
