//
//  HowActiveYouView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 22.08.2024.
//

import SwiftUI

struct HowActiveYouView: View {
    @EnvironmentObject var userInputModel: UserInputModel
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel = HowActiveYouVM()
    @State private var selectedActivity: ActivityItem?
    @State private var activities: [ActivityItem] = []
    
    var body: some View {
            BaseView(currentViewModel: viewModel,
                     background: .lightTeal,
                     showIndicator: $viewModel.showIndicator) {
                NavigationLink(
                    destination: PurposeInputView()
                        .environmentObject(userInputModel),
                    isActive: $viewModel.goToPurpose
                ) {}
                
                VStack(spacing:0) {
                    CUILeftHeadline(
                        title: "Details About You",
                        subtitle: "Exclude sports and strenuous activities like running, playing basketball, or working out.",
                        style: .black,
                        bottomPadding: 0)
                    ScrollView {
                        VStack(spacing: -10) {
                            ForEach(viewModel.activityItems, id: \.self) { activity in
                                ActivityElement(
                                    title: activity.title,
                                    subtitle: activity.subtitle,
                                    isSelected: activity == selectedActivity)
                                .onTapGesture {
                                    selectedActivity = activity
                                }
                            }
                        }
                    }
                    Spacer()
                    CUIButton(text: "NEXT") {
                        userInputModel.activity = selectedActivity?.title
                        viewModel.goToPurpose = true
                    }
                }
                .onAppear {
                    viewModel.fetchActivityItems()
                }
            }
                     .navigationBarBackButtonHidden()
                     .navigationBarItems(
                        leading:
                            CUIBackButton()
                     )
                     .toolbar {
                         ToolbarItem(placement: .navigationBarTrailing) {
                             HStack(spacing: 0) {
                                 Spacer(minLength: 0)
                                 CUIProgressView(progressCount: 3, currentProgress: 2)
                                     .padding(.trailing, UIScreen.screenWidth * 0.17)
                             }
                         }
                     }
    }
}
#Preview {
    HowActiveYouView()
}
