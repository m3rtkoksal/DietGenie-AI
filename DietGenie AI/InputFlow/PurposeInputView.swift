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
    
    @StateObject private var viewModel = PurposeInputVM()
    @State private var selectedPurposeSegmentIndex = 0
    var body: some View {
       
        BaseView(currentViewModel: viewModel,
                 background: .black,
                 showIndicator: $viewModel.showIndicator) {
            NavigationLink(
                destination: DietProgramView()
                    .environmentObject(userInputModel),
                isActive: $viewModel.goToDietProgram
            ) {}
            VStack {
                CUILeftHeadline(
                    title: "Details About You",
                    subtitle: "Please select your purpose",
                    style: .black,
                    bottomPadding: 0)
                Spacer()
                
                SegmentedControlView(selectedIndex: $selectedPurposeSegmentIndex,
                                     titles: viewModel.purposeSegmentItems)
                Spacer()
                
                CUIButton(text: "NEXT") {
                    viewModel.showIndicator = true
                    userInputModel.purpose = viewModel.purposeSegmentItems[selectedPurposeSegmentIndex].title
                    viewModel.goToDietProgram = true
                }
            }
            .onAppear {
                viewModel.fetchSegmentItems()
            }
            .onDisappear {
                self.viewModel.showIndicator = false
            }
        }
                 .navigationBarTitle("DietGenie AI")
                 .navigationBarBackButtonHidden()
                 .navigationBarItems(leading: CUIBackButton())
    }
}
