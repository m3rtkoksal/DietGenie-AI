//
//  PasswordResetView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 17.08.2024.
//

import SwiftUI
import FirebaseAuth

struct PasswordResetView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel = BaseViewModel()
    @State private var errorMessage = ""
    @State private var showAlert = false
    @StateObject private var emailValidator = DefaultTextValidator(predicate: ValidatorHelper.emailPredicate)
    @State private var scrollViewContentOffset: CGFloat = 0
    
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .lightTeal,
                 showIndicator: $viewModel.showIndicator,
                 scrollViewOffset: scrollViewContentOffset) {
            TrackableScrollView(.vertical,
                                showIndicators: false,
                                contentOffset: $scrollViewContentOffset) {
                CUILeftHeadline(
                    title: "Forgot Password",
                    subtitle: "Please enter your email address to recieve your password reset code",
                    style: .black)
                
                CUIValidationField(
                    placeholder: "Please enter your email",
                    prompt: "Wrong email format",
                    text: $emailValidator.text,
                    isCriteriaValid: $emailValidator.isCriteriaValid,
                    isNotValid: $emailValidator.isNotValid,
                    showPrompt: $emailValidator.showPrompt,
                    style: .emailAddress)
                
                CUIButton(text: "Reset Password") {
                    sendPasswordReset()
                    self.showAlert = true
                }
                .padding(.top,110)
                LottieView(lottieFile: "forgotPass_animation", loopMode: .loop)
                    .padding(.top)
            }
            .navigationBarTitle("Forgot Password")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading:
                    CUIBackButton(toRoot: true)
            )
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Password Reset"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK")) {
                        showAlert = false
                        self.presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
    func sendPasswordReset() {
            Auth.auth().sendPasswordReset(withEmail: emailValidator.text) { error in
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                } else {
                    self.errorMessage = "Password reset email sent. Please check your inbox."
                }
            }
        }
}

#Preview {
    PasswordResetView()
}
