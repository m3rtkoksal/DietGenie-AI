//
//  WelcomeView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 17.08.2024.
//

import SwiftUI
import FirebaseAuth

struct WelcomeView: View {
    @EnvironmentObject var userInputModel: UserInputModel
    @StateObject private var emailValidator = DefaultTextValidator(predicate: ValidatorHelper.emailPredicate)
    @StateObject private var passwordValidator = DefaultTextValidator(predicate: ValidatorHelper.passwordPredicate)
    @StateObject private var viewModel = WelcomeVM()
    @State private var errorMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .black,
                 showIndicator: $viewModel.showIndicator) {
            VStack {
                CUILeftHeadline(
                    title: "Welcome",
                    subtitle: "Enjoy the simplest way to achive your dream physique",
                    style: .red,
                    bottomPadding: 20)
                Spacer()
                CUIValidationField(
                    placeholder: "Please enter email",
                    prompt: "Wrong email format",
                    text: $emailValidator.text,
                    isCriteriaValid: $emailValidator.isCriteriaValid,
                    isNotValid: $emailValidator.isNotValid,
                    showPrompt: $emailValidator.showPrompt,
                    style: .emailAddress
                )
                
                CUIPasswordValidationField(
                    placeholder: "Please enter password",
                    prompt: "Password must be 1 capital 1 small letter and 6 numbers",
                    willShowPrompt: true,
                    text: $passwordValidator.text,
                    isCriteriaValid: $passwordValidator.isCriteriaValid,
                    isNotValid: $passwordValidator.isNotValid,
                    showPrompt: $passwordValidator.showPrompt)
                
                HStack {
                    Button {
                        viewModel.goToRegisterView = true
                    } label: {
                        Text("Signup")
                            .foregroundColor(.lightGray200)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.teal, lineWidth: 2))
                    }
                    Spacer()
                    Button {
                        viewModel.goToPasswordReset = true
                    } label: {
                        Text("Forgot Password")
                            .foregroundColor(.lightGray200)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.teal, lineWidth: 2))
                    }
                }
                .padding()
                Spacer()
                CUIButton(text: "Login") {
                    signIn()
                }
            }
            .fullScreenCover(isPresented: $viewModel.goToSelectInputView) {
                NavigationView {
                    SelectInputMethodView()
                        .environmentObject(userInputModel)
                }
                .environmentObject(
                    BindingRouter($viewModel.goToSelectInputView)
                )
            }
            .fullScreenCover(isPresented: $viewModel.goToRegisterView) {
                NavigationView {
                    RegisterView()
                        .environmentObject(userInputModel)
                }
                .environmentObject(
                    BindingRouter($viewModel.goToRegisterView)
                )
            }
            .fullScreenCover(isPresented: $viewModel.goToPasswordReset) {
                NavigationView {
                    PasswordResetView()
                        .environmentObject(userInputModel)
                }
                .environmentObject(
                    BindingRouter($viewModel.goToPasswordReset)
                )
            }
           
            .navigationBarTitle("DietGenie AI")
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Wrong email or password"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("Try Again")) {
                        showAlert = false
                    }
                )
            }
        }
    }
    func signIn() {
        Auth.auth().signIn(withEmail: emailValidator.text, password: passwordValidator.text) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                self.showAlert = true
            } else {
                errorMessage = "User signed in successfully!"
                AuthenticationManager.shared.logIn()
                viewModel.goToSelectInputView = true
                emailValidator.text = ""
                passwordValidator.text = ""
            }
        }
    }
}


struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(UserInputModel())
    }
}
