//
//  SelectInputMethodView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

struct SelectInputMethodView: View {
    @EnvironmentObject var userInputModel: UserInputModel
    @StateObject private var viewModel = InputViewModel()
    @StateObject private var healthKitManager = HealthKitManager()
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
            VStack(spacing: 50) {
                CUIButton(text: "Create Program with HealthKit") {
                    if healthKitManager.isAuthorized {
                        fetchAndNavigate()
                    }
                }
                CUIButton(text: "Enter Manually") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.viewModel.goToGenderInputPage = true
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
        .navigationBarBackButtonHidden()
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
}

#Preview {
    SelectInputMethodView()
}
