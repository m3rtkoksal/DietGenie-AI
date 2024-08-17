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
    @StateObject private var passwordValidator = DefaultTextValidator(predicate: ValidatorHelper.emptyPasswordPredicate)
    @StateObject private var viewModel = InputViewModel()
    @State private var errorMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .black,
                 showIndicator: $viewModel.showIndicator) {
            NavigationLink(
                destination: SelectInputMethodView()
                    .environmentObject(userInputModel),
                isActive: $viewModel.goToSelectInputView
            ) {}
            NavigationLink(
                destination: RegisterView()
                    .environmentObject(userInputModel),
                isActive: $viewModel.goToRegisterView
            ) {}
            NavigationLink(
                destination: PasswordResetView()
                    .environmentObject(userInputModel),
                isActive: $viewModel.goToPasswordReset
            ) {}
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
                CUIValidationField(
                    placeholder: "Please enter password",
                    prompt: "Wrong password format",
                    text: $passwordValidator.text,
                    isCriteriaValid: $passwordValidator.isCriteriaValid,
                    isNotValid: $passwordValidator.isNotValid,
                    showPrompt: $passwordValidator.showPrompt,
                    style: .numberPad
                )
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
                        signIn()
                    } label: {
                        Text("Login")
                            .foregroundColor(.lightGray200)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.teal, lineWidth: 2))
                        
                        
                    }
                }
                .padding()
                Spacer()
                CUIButton(text: "Forgot Password") {
                    viewModel.goToPasswordReset = true
                }
                
            }
            .onAppear {
                emailValidator.text = ""
                passwordValidator.text = ""
            }
            .navigationBarTitle("DietGenie AI")
            .navigationBarHidden(true)
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
                viewModel.goToSelectInputView = true
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
