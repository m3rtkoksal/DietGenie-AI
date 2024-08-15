//
//  InputView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI
import HealthKit

struct GenderInputView: View {
    // MARK: - Properties
    @EnvironmentObject var userInputModel: UserInputModel
    @StateObject private var viewModel = InputViewModel()
    @StateObject private var healthKitManager = HealthKitManager()
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var choosenItem = CUIDropdownItemModel(text: "")
    @State private var showGenderMenu = false
    @State private var selectedGenderSegmentIndex = 0
    
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .black,
                 showIndicator: $viewModel.showIndicator) {
            NavigationLink(
                destination: BMIInputView()
                    .environmentObject(userInputModel),
                isActive: $viewModel.goToBMIInputPage
            ) {}
            
            VStack {
                CUILeftHeadline(
                    title: "Details About You",
                    subtitle: "Please select your gender",
                    style: .red,
                    bottomPadding: 0)
                Spacer()
                SegmentedControlView(selectedIndex: $selectedGenderSegmentIndex, titles: viewModel.genderSegmentItems)
                //                    SegmentedControlView(selectedIndex: $selectedPurposeSegmentIndex, titles: viewModel.purposeSegmentItems)
                //                    CUIDropdownField(title: "filterViewTransactionType", isExpanded: $showGenderMenu,
                //                        choosenItem: $choosenItem)
                Spacer()
                CUIButton(text: "Next") {
                    let selectedGender = viewModel.genderSegmentItems[selectedGenderSegmentIndex].title
                    if let hkBiologicalSex = genderStringToHKBiologicalSex(selectedGender) {
                        self.userInputModel.gender = hkBiologicalSex
                    } else {
                        // Handle invalid gender if necessary
                        print("Invalid gender selection")
                    }
                    self.viewModel.goToBMIInputPage = true
                }
            }
            
            .onAppear {
                viewModel.fetchMenuItems()
                healthKitManager.requestAuthorization()
            }
            // MARK: - Profile Photo Menu
            .ndDropdownModifier(itemList: $viewModel.menuPickerItems,
                                isExpanded: $showGenderMenu,
                                choosenItem: $choosenItem)
        }
                 .navigationBarTitle("DietGenie AI")
                 .navigationBarBackButtonHidden()
                 .navigationBarItems(
                    leading:
                        CUIBackButton()
                 )
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
