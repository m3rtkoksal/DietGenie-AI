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
    @StateObject private var viewModel = InputViewModel()
    @State private var errorMessage = ""
    @State private var showAlert = false
    @StateObject private var emailValidator = DefaultTextValidator(predicate: ValidatorHelper.emailPredicate)
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .black,
                 showIndicator: $viewModel.showIndicator) {
            VStack{
                CUILeftHeadline(
                    title: "New Password",
                    subtitle: "Please enter your email address to recieve password",
                    style: .red,
                    bottomPadding: 20)
                CUIValidationField(
                    placeholder: "Please enter your email",
                    prompt: "Wrong email format",
                    text: $emailValidator.text,
                    isCriteriaValid: $emailValidator.isCriteriaValid,
                    isNotValid: $emailValidator.isNotValid,
                    showPrompt: $emailValidator.showPrompt,
                    style: .emailAddress)
                .padding(.top)
                Spacer()
                CUIButton(text: "Send Email") {
                    sendPasswordReset()
                    self.showAlert = true
                }
            }
            .navigationBarTitle("DietGenie AI")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading:
                   CUIBackButton()
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
