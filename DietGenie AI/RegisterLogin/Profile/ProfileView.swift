//
//  ProfileView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 25.08.2024.
//

import SwiftUI
import HealthKit

struct ProfileView: View {
    @EnvironmentObject var userInputModel: UserInputModel
    @StateObject private var healthKitManager = HealthKitManager()
    @StateObject private var emailValidator = DefaultTextValidator(predicate: ValidatorHelper.emailPredicate)
    @StateObject private var passwordValidator = DefaultTextValidator(predicate: ValidatorHelper.passwordPredicate)
    @StateObject private var viewModel = ProfileVM()
    @StateObject private var keyboardObserver = KeyboardObserver()
    
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .lightTeal,
                 showIndicator: $viewModel.showIndicator) {
            VStack {
                CUILeftHeadline(
                    title: "Information of You",
                    subtitle: "You can see details of your profile from this list",
                    style: .black)
                ScrollView {
                    CUIPersonalInfoElement(title: "Name",
                                           description: userInputModel.firstName ?? "",
                                           buttonIcon: "") { }
                    CUIPersonalInfoElement(title: "Surname",
                                           description: userInputModel.lastName ?? "",
                                           buttonIcon: "") { }
                    CUIPersonalInfoElement(title: "Birthday",
                                           description: userInputModel.birthday ?? "",
                                           buttonIcon: "") { }
                    CUIPersonalInfoElement(title: "Email",
                                           description: userInputModel.email ?? "",
                                           buttonIcon: "") { }
                    CUIPersonalInfoElement(
                        title: "Gender",
                        description: healthKitManager.hkBiologicalSexToGenderString(userInputModel.gender ?? HKBiologicalSex(rawValue: 3)!),
                        buttonIcon: ""
                    ) { }
                    CUIPersonalInfoElement(title: "Height",
                                           description: "\(Int((userInputModel.height ?? 0.0) * 100)) cm",
                                           buttonIcon: "") { }
                    CUIPersonalInfoElement(title: "Weight",
                                           description: "\(Int((userInputModel.weight ?? 0.0))) kg",
                                           buttonIcon: "") { }
                    CUIPersonalInfoElement(title: "Body Fat Percentage",
                                           description: "\(Int((userInputModel.bodyFatPercentage ?? 0.0) * 100)) %",
                                           buttonIcon: "") { }
                    CUIPersonalInfoElement(title: "Lean Body Mass",
                                           description: "\(Int((userInputModel.leanBodyMass ?? 0.0))) kg",
                                           buttonIcon: "") { }
                    CUIPersonalInfoElement(title: "Resting Energy",
                                           description: "\(Int((userInputModel.restingEnergy ?? 0.0))) kcal",
                                           buttonIcon: "") { }
                    CUIPersonalInfoElement(title: "Active Energy",
                                           description: "\(Int((userInputModel.activeEnergy ?? 0.0))) kcal",
                                           buttonIcon: "") { }
                }
                .padding(.horizontal)
            }
        }
                 .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ProfileView()
}
