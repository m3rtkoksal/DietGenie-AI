//
//  OnboardingView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 19.08.2024.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var userInputModel: UserInputModel
    @StateObject private var viewModel = OnboardingVM()
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .solidWhite,
                 showIndicator: $viewModel.showIndicator) {
            ZStack{
                CustomEllipseShape(width: UIScreen.screenWidth * 2.23, height: UIScreen.screenHeight * 0.85)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.topGreen, Color.bottomBlue]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .offset(y: -120)
                
                    LottieView(lottieFile: "DietGenie_animation",
                               loopMode: .loop)
                    .offset(y: -140)
                    .frame(width: UIScreen.screenWidth * 0.9, height:UIScreen.screenHeight * 0.58)
            }
            VStack(spacing: 20) {
                Spacer()
                Group {
                    Text("Diet Genie")
                        .font(.montserrat(.bold, size: 24))
                    Text("Helps you find the simplest way to achieve your dream physique")
                        .font(.montserrat(.medium, size: 14))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(width: 250)
                .padding(.bottom)
               
                Spacer()
                    .frame(height: 30)
                CUIButton(text: "Login") {
                    viewModel.goToLogin = true
                }
                Button("Create New Account") {
                    viewModel.goToRegister = true
                }
                .font(.montserrat(.medium, size: 17))
            }
            .foregroundColor(.black)
            .fullScreenCover(isPresented: $viewModel.goToRegister) {
                NavigationView {
                    RegisterView()
                        .environmentObject(userInputModel)
                }
                .environmentObject(
                    BindingRouter($viewModel.goToRegister)
                )
            }
            .fullScreenCover(isPresented: $viewModel.goToLogin) {
                NavigationView {
                    LoginView()
                        .environmentObject(userInputModel)
                }
                .environmentObject(
                    BindingRouter($viewModel.goToLogin)
                )
            }
        }
    }
}

#Preview {
    OnboardingView()
}
