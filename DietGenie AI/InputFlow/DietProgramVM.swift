//
//  DietProgramVM.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import Foundation

class DietProgramVM: BaseViewModel {
    @Published var mealItems: [String] = []
    @Published var mealIcons: [String] = []
    
    func getMealIcons() {
        // List of SF Symbols icons for different meal types
        self.mealIcons =  [
            "pan_egg",
            "banana_apple",
            "green-salad",
            "sandwich",
            "meat",
            "falafel"
        ]
    }
}
