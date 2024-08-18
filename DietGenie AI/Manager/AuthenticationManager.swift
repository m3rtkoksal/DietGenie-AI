//
//  AuthenticationManager.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import Foundation

class AuthenticationManager {
    static let shared = AuthenticationManager()
    private let isLoggedInKey = "isLoggedIn"
    
    private init() {}
    
    var isLoggedIn: Bool {
        get {
            UserDefaults.standard.bool(forKey: isLoggedInKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isLoggedInKey)
        }
    }
    
    func logIn() {
        isLoggedIn = true
    }
    
    func logOut() {
        isLoggedIn = false
    }
}
