//
//  RegisterView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 17.08.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct RegisterView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userInputModel: UserInputModel
    @StateObject private var nameValidator = DefaultTextValidator(predicate: ValidatorHelper.firstNamePredicate)
    @StateObject private var surnameValidator = DefaultTextValidator(predicate: ValidatorHelper.lastNamePredicate)
    @StateObject private var emailValidator = DefaultTextValidator(predicate: ValidatorHelper.emailPredicate)
    @StateObject private var passwordValidator = DefaultTextValidator(predicate: ValidatorHelper.passwordPredicate)
    @StateObject private var viewModel = RegisterVM()
    @State private var errorMessage = ""
    @State private var errorTitle = ""
    @State private var showAlert = false
    @State private var choosenItem = CUIDropdownItemModel(text: "")
    @State private var showGenderMenu = false
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
                        title: "Registiration",
                        subtitle: "Please enter your information to create account",
                        style: .black,
                        bottomPadding: 0)
                    VStack(spacing: 10){
                        CUIValidationField(
                            placeholder: "First name",
                            prompt: "Wrong name format",
                            text: $nameValidator.text,
                            isCriteriaValid: $nameValidator.isCriteriaValid,
                            isNotValid: $nameValidator.isNotValid,
                            showPrompt: $nameValidator.showPrompt,
                            style: .emailAddress
                        )
                        CUIValidationField(
                            placeholder: "Last name",
                            prompt: "Wrong name format",
                            text: $surnameValidator.text,
                            isCriteriaValid: $surnameValidator.isCriteriaValid,
                            isNotValid: $surnameValidator.isNotValid,
                            showPrompt: $surnameValidator.showPrompt,
                            style: .emailAddress
                        )
                        CUIValidationField(
                            placeholder: "Email address",
                            prompt: "Wrong email format",
                            text: $emailValidator.text,
                            isCriteriaValid: $emailValidator.isCriteriaValid,
                            isNotValid: $emailValidator.isNotValid,
                            showPrompt: $emailValidator.showPrompt, style: .emailAddress
                        )
                        
                        CUIPasswordValidationField(
                            placeholder: "Password",
                            prompt: "Password does not meet criteria",
                            willShowPrompt: true,
                            text: $passwordValidator.text,
                            isCriteriaValid: $passwordValidator.isCriteriaValid,
                            isNotValid: $passwordValidator.isNotValid,
                            showPrompt: $passwordValidator.showPrompt)
                        VStack(spacing: 50) {
                            CUIButton(text: "Create Account") {
                                self.viewModel.showIndicator = true
                                self.signUp(
                                    email: emailValidator.text,
                                    password: passwordValidator.text,
                                    name: nameValidator.text,
                                    surname: surnameValidator.text
                                )
                            }
                            CUIDivider(title: "or Register with")
                            VStack(spacing: 10) {
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
                            Spacer()
                            Button(action: {
                                viewModel.goToLogin = true
                            }) {
                                Text("Already have an account? ")
                                    .font(.montserrat(.medium, size: 15)) +
                                Text("Login!")
                                    .font(.montserrat(.bold, size: 15))
                            }
                            .foregroundColor(.black)
                        }
                        .padding(.top, 40)
                    }
                    .frame(width: UIScreen.screenWidth)
                    .padding(.top)
                }
                
            
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(errorTitle),
                    message: Text(errorMessage.description),
                    dismissButton: .default(Text("OK")) {
                        showAlert = false
                        if errorTitle.contains("success") {
                            self.viewModel.showIndicator = false
                            viewModel.goToHealthPermission = true
                        }
                    }
                )
            }
//            .navigationBarTitle("Registiration")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading:
                    CUIBackButton(toRoot: true)
            )
            .fullScreenCover(isPresented: $viewModel.goToLogin) {
                NavigationView {
                   LoginView()
                        .environmentObject(userInputModel)
                }
                .environmentObject(
                    BindingRouter($viewModel.goToLogin)
                )
            }
            .fullScreenCover(isPresented: $viewModel.goToHealthPermission) {
                NavigationView {
                   HealthKitPermissionView()
                        .environmentObject(userInputModel)
                }
                .environmentObject(
                    BindingRouter($viewModel.goToHealthPermission)
                )
            }
            .onAppear {
                viewModel.fetchMenuItems()
            }
        }
    }
    func signUp(email: String, password: String, name: String, surname: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showAlert = true
            } else if let user = authResult?.user {
                // User is successfully authenticated, now save additional information to Firestore
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).setData([
                    "userId": user.uid,
                    "name": name,
                    "surname": surname,
                    "email": email
                ]) { err in
                    if let err = err {
                        self.errorTitle = "Error saving user data"
                        self.errorMessage = err.localizedDescription
                        self.showAlert = true
                    } else {
                        self.errorTitle = "User signed up and data saved successfully!"
                        self.errorMessage = ""
                        self.showAlert = true
                    }
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
