//
//  DietPlanDetailView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import SwiftUI

struct DietPlanDetailView: View {
    let dietPlan: DietPlan
    @StateObject private var viewModel = BaseViewModel()
    
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .black,
                 showIndicator: $viewModel.showIndicator
        ) {
            VStack {
                CUILeftHeadline(
                    title: "Your Saved Diet Plans",
                    subtitle: "",
                    style: .black,
                    bottomPadding: 50)
                ScrollView {
                    ForEach(dietPlan.meals, id: \.self) { meal in
                        MealCardElementView(meal: meal)
                    }
                    .navigationBarTitle("DietGenie AI")
                    .navigationBarBackButtonHidden()
                    .navigationBarItems(
                        leading:
                            CUIBackButton()
                    )
                }
            }
        }
       
    }
}
