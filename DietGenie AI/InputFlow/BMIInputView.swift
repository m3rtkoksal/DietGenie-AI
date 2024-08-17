//
//  BMIInputView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

struct BMIInputView: View {
    @EnvironmentObject var userInputModel: UserInputModel
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject private var ageValidator = DefaultTextValidator(predicate: ValidatorHelper.agePredicate)
    @StateObject private var heightValidator = DefaultTextValidator(predicate: ValidatorHelper.heightPredicate)
    @StateObject private var weightValidator = DefaultTextValidator(predicate: ValidatorHelper.weightPredicate)
    @StateObject private var viewModel = InputViewModel()
    @State private var selectedPurposeSegmentIndex = 0
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .black,
                 showIndicator: $viewModel.showIndicator) {
            NavigationLink(
                destination: PurposeInputView()
                    .environmentObject(userInputModel),
                isActive: $viewModel.goToPurposeInputPage
            ) {}
            
            VStack {
                CUILeftHeadline(
                    title: "Details About You",
                    subtitle: "Please enter below fields",
                    style: .red,
                    bottomPadding: 0)
                Spacer()
                CUIValidationField(
                    placeholder: "Please enter height in cm",
                    prompt: "Please enter valid height in cm",
                    text: $heightValidator.text,
                    isCriteriaValid: $heightValidator.isCriteriaValid,
                    isNotValid: $heightValidator.isNotValid,
                    showPrompt: $heightValidator.showPrompt,
                    style: .numberPad
                )
                .keyboardType(.numberPad)
                CUIValidationField(
                    placeholder: "Please enter weight in kg",
                    prompt: "Please enter valid weight in kg",
                    text: $weightValidator.text,
                    isCriteriaValid: $weightValidator.isCriteriaValid,
                    isNotValid: $weightValidator.isNotValid,
                    showPrompt: $weightValidator.showPrompt,
                    style: .numberPad
                )
                .keyboardType(.numberPad)
                Spacer()
                CUIButton(text: "NEXT") {
                    if let age = Int(ageValidator.text) {
                        self.userInputModel.age = age
                    }
                    if let height = Double(heightValidator.text) {
                        self.userInputModel.height = height
                    }
                    if let weight = Double(weightValidator.text) {
                        self.userInputModel.weight = weight
                    }
                    self.viewModel.goToPurposeInputPage = true
                }
            }
            
            
            .onAppear {
                viewModel.fetchMenuItems()
            }
            // MARK: - Profile Photo Menu
//            .ndDropdownModifier(itemList: $viewModel.menuPickerItems,
//                                isExpanded: $showGenderMenu,
//                                choosenItem: $choosenItem)
        }
                 .navigationBarTitle("DietGenie AI")
                 .navigationBarBackButtonHidden()
                 .navigationBarItems(
                     leading:
                        CUIBackButton()
                 )
    }
}
