//
//  WelcomeView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 17.08.2024.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var userInputModel: UserInputModel
    @StateObject private var emailValidator = DefaultTextValidator(predicate: ValidatorHelper.emailPredicate)
    @StateObject private var passwordValidator = DefaultTextValidator(predicate: ValidatorHelper.passwordPredicate)
    @StateObject private var viewModel = LoginVM()
    @StateObject private var keyboardObserver = KeyboardObserver()
    @State private var errorMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .lightTeal,
                 showIndicator: $viewModel.showIndicator) {
            VStack {
                ScrollView {
                    CUILeftHeadline(
                        title: "Welcome to Diet Genie",
                        subtitle: "Hello there, sign in to  continue!",
                        style: .black,
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
                        Button("Forgot Password") {
                            viewModel.goToPasswordReset = true
                        }
                        .font(.montserrat(.semiBold, size: 14))
                        .foregroundColor(.black)
                        .padding(.trailing, 30)
                    }
                    .padding()
                   
                    CUIButton(text: "Login") {
                        signIn()
                    }
                    Spacer()
                        .frame(height: 110)
                  
                }
                VStack(spacing: 50){
                    Spacer()
                    CUIDivider(title: "Or Login with")
                    VStack(spacing:10) {
                        CUIButton(
                            image: "google-icon",
                            text: "Connect with Google",
                            backgroundColor: .white) {
                               
                            }
                        CUIButton(
                            image: "apple_icon",
                            text: "Connect with Apple",
                            backgroundColor: .black,
                            textColor: .white) {
                                
                            }
                    }
                    
                    Button(action: {
                        viewModel.goToRegister = true
                    }) {
                        Text("Don’t have an account? ")
                            .font(.montserrat(.medium, size: 15)) +
                        Text("Register!")
                            .font(.montserrat(.bold, size: 15))
                    }
                    .foregroundColor(.black)

                }
                .hiddenConditionally(isHidden: keyboardObserver.isKeyboardVisible)
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
            .fullScreenCover(isPresented: $viewModel.goToRegister) {
                NavigationView {
                    RegisterView()
                        .environmentObject(userInputModel)
                }
                .environmentObject(
                    BindingRouter($viewModel.goToRegister)
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
            .navigationBarItems(
                leading:
                   CUIBackButton(toRoot: true)
            )
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
        LoginView()
            .environmentObject(UserInputModel())
    }
}
