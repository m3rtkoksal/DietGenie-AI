//
//  PurposeInputView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

struct PurposeInputView: View {
    @EnvironmentObject var userInputModel: UserInputModel
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    @StateObject private var viewModel = InputViewModel()
    @State private var selectedPurposeSegmentIndex = 0
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .black,
                 showIndicator: $viewModel.showIndicator) {
            NavigationLink(
                destination: DietProgramView()
                    .environmentObject(userInputModel),
                isActive: $viewModel.goToDietProgramView
            ) {}
            
            VStack {
                CUILeftHeadline(
                    title: "Details About You",
                    subtitle: "Please select your purpose",
                    style: .red,
                    bottomPadding: 0)
                Spacer()
                SegmentedControlView(selectedIndex: $selectedPurposeSegmentIndex,
                                     titles: viewModel.purposeSegmentItems)
                //                    CUIDropdownField(title: "filterViewTransactionType", isExpanded: $showGenderMenu,
                //                        choosenItem: $choosenItem)
                Spacer()
                CUIButton(text: "NEXT") {
                    handleNextButtonTap()
                }
            }
            
            .onAppear {
                viewModel.fetchMenuItems()
            }
            .onDisappear {
                self.viewModel.showIndicator = false
            }
            // MARK: - 
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
    private func handleNextButtonTap() {
            viewModel.showIndicator = true
            userInputModel.purpose = viewModel.purposeSegmentItems[selectedPurposeSegmentIndex].title
            
            // Simulate a delay or perform asynchronous work
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                viewModel.showIndicator = false
                viewModel.goToDietProgramView = true
            }
        }
}
