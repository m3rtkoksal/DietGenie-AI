//
//  PurposeInputVM.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import Foundation

class PurposeInputVM: BaseViewModel {
    @Published var purposeItems: [PurposeItem] = []
    @Published var goToDietProgram = false

    func fetchPurposeItems() {
        self.purposeItems = [
            PurposeItem(title: "Lose weight", icon: "loseWeight"),
            PurposeItem(title: "Maintain weight", icon: "maintainWeight"),
            PurposeItem(title: "Gain weight", icon: "gainFat"),
            PurposeItem(title: "Gain muscle", icon: "gainMuscle")
        ]
    }
}
