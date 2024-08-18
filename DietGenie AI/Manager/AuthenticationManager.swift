//
//  AuthenticationManager.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import Foundation
import Combine

class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    private let isLoggedInKey = "isLoggedIn"
    
    @Published var isLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: isLoggedInKey)
        }
    }
    
    private init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
    
    func logIn() {
        isLoggedIn = true
    }
    
    func logOut() {
        isLoggedIn = false
    }
}
