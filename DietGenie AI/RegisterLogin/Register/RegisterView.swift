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
    @StateObject private var birthdayValidator = DefaultTextValidator(predicate: ValidatorHelper.datePredicate)
    @State private var birthday: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    @StateObject private var viewModel = RegisterVM()
    @State private var errorMessage = ""
    @State private var errorTitle = ""
    @State private var showAlert = false
    @State private var choosenItem = CUIDropdownItemModel(text: "")
    @State private var showGenderMenu = false
    @State private var isDatePickerVisible = true
    
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .black,
                 showIndicator: $viewModel.showIndicator) {
            VStack {
                CUILeftHeadline(
                    title: "Registiration",
                    subtitle: "Please enter your information to create account",
                    style: .red,
                    bottomPadding: 20)
                ScrollView {
                    CUIValidationField(
                        placeholder: "first name",
                        prompt: "Wrong name format",
                        text: $nameValidator.text,
                        isCriteriaValid: $nameValidator.isCriteriaValid,
                        isNotValid: $nameValidator.isNotValid,
                        showPrompt: $nameValidator.showPrompt,
                        style: .emailAddress
                    )
                    CUIValidationField(
                        placeholder: "last name",
                        prompt: "Wrong name format",
                        text: $surnameValidator.text,
                        isCriteriaValid: $surnameValidator.isCriteriaValid,
                        isNotValid: $surnameValidator.isNotValid,
                        showPrompt: $surnameValidator.showPrompt,
                        style: .emailAddress
                    )
                    CUIValidationField(
                        placeholder: "Please enter email",
                        prompt: "Wrong email format",
                        text: $emailValidator.text,
                        isCriteriaValid: $emailValidator.isCriteriaValid,
                        isNotValid: $emailValidator.isNotValid,
                        showPrompt: $emailValidator.showPrompt, style: .emailAddress
                    )
                    
                    CUIPasswordValidationField(
                        placeholder: "Please enter password",
                        prompt: "Password does not meet criteria",
                        willShowPrompt: true,
                        text: $passwordValidator.text,
                        isCriteriaValid: $passwordValidator.isCriteriaValid,
                        isNotValid: $passwordValidator.isNotValid,
                        showPrompt: $passwordValidator.showPrompt)
                    
                    ZStack(alignment: .top) {
                        CUIValidationField(
                            placeholder: "Please select birthday",
                            prompt: "",
                            text: $birthdayValidator.text,
                            isCriteriaValid: $birthdayValidator.isCriteriaValid,
                            isNotValid: $birthdayValidator.isNotValid,
                            showPrompt: .constant(false), style: .default)
                        .disabled(true)
                        .background(Color.clear)
                        DatePickerView()
                    }
                    CUIDropdownField(
                        title: "Please select gender",
                        isExpanded: $showGenderMenu,
                        choosenItem: $choosenItem)
                    .padding(.horizontal, 20)
                }
               Spacer()
                CUIButton(text: "Confirm") {
                    self.signUp(
                        email: emailValidator.text,
                        password: passwordValidator.text,
                        name: nameValidator.text,
                        surname: surnameValidator.text,
                        birthday: birthday.getFormattedDate(format: "dd.MM.yyyy"),
                        gender: choosenItem.text)
                }

            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(errorTitle),
                    message: Text(errorMessage.description),
                    dismissButton: .default(Text("OK")) {
                        showAlert = false
                        if errorTitle.contains("success") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
            .navigationBarTitle("DietGenie AI")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading:
                   CUIBackButton(toRoot: true)
            )
            .ndDropdownModifier(
                itemList: $viewModel.menuPickerItems,
                isExpanded: $showGenderMenu,
                choosenItem: $choosenItem)
            .onAppear {
                viewModel.fetchMenuItems()
            }
        }
    }
    func signUp(email: String, password: String, name: String, surname: String, birthday: String, gender: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showAlert = true
            } else if let user = authResult?.user {
                // User is successfully authenticated, now save additional information to Firestore
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).setData([
                    "name": name,
                    "surname": surname,
                    "birthday": birthday,
                    "gender": gender,
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
    private func DatePickerView() -> some View {
        HStack{
            Spacer()
            ZStack{
                DatePicker("",
                           selection: $birthday,
                           in: ...Calendar.current.date(byAdding: .year, value: -18, to: Date())!,
                           displayedComponents: .date
                )
                .frame(width: 25, height: 25)
                .offset(x: 80, y: 0)
                .labelsHidden()
                .clipped()
                .background(Color.clear)
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.textColorsNeutral)
                    .offset(x: 45, y: 0)
                    .onTapGesture {
                        isDatePickerVisible.toggle()
                    }
                    .onChange(of: birthday) { newValue in
                        birthdayValidator.text = newValue.getFormattedDate(format: "dd.MM.yyyy")
                    }
            }
            .offset(x: -10)
            .frame(width: 50, height: 32)
            .background(Color.clear)
        }
        .frame(width: UIScreen.screenWidth / 1.2)
        .offset(x: -20, y: 15)
        .background(Color.clear)
    }
}

#Preview {
    RegisterView()
}
