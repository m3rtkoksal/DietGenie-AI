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
    @State private var selectedPurpose: PurposeItem?
    var body: some View {
        
        BaseView(currentViewModel: viewModel,
                 background: .lightTeal,
                 showIndicator: $viewModel.showIndicator) {
            NavigationLink(
                destination: LoadingView()
                    .environmentObject(userInputModel),
                isActive: $viewModel.goToLoadingView
            ) {}
            VStack(spacing: 20) {
                CUILeftHeadline(
                    title: "What’s your goal?",
                    subtitle: "Let’s focus on one goal to begin with.",
                    style: .black)
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.purposeItems, id: \.self) { purpose in
                            PurposeElement(
                                title: purpose.title,
                                icon: purpose.icon,
                                isSelected: purpose == selectedPurpose)
                            .onTapGesture {
                                selectedPurpose = purpose
                            }
                        }
                    }
                }
                CUIButton(text: "NEXT") {
                    viewModel.showIndicator = true
                    userInputModel.purpose = selectedPurpose?.title
                    viewModel.goToLoadingView = true
                }
            }
            .onAppear {
                viewModel.fetchPurposeItems()
                print("Purpose Input appeared.")
            }
            .onDisappear {
                self.viewModel.showIndicator = false
                print("Purpose Input dissappeared.")
            }
        }
                 .navigationTitle("")
                 .navigationBarBackButtonHidden()
                 .navigationBarItems(
                    leading:
                        CUIBackButton()
                 )
                 .toolbar {
                     ToolbarItem(placement: .navigationBarTrailing) {
                         HStack(spacing: 0) {
                             Spacer(minLength: 0)
                             CUIProgressView(progressCount: 3, currentProgress: 3)
                                 .padding(.trailing, UIScreen.screenWidth * 0.17)
                         }
                     }
                 }
    }
}
