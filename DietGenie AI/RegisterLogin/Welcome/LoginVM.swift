//
//  WelcomeVM.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import Foundation

class LoginVM: BaseViewModel {
    @Published var goToSelectInputView = false
    @Published var goToRegisterView = false
    @Published var goToPasswordReset = false
    @Published var goToRegister = false
}
