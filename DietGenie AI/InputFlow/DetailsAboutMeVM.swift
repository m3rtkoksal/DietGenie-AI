//
//  GenderInputVM.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import Foundation

class DetailsAboutMeVM: BaseViewModel {
    
    @Published var genderSegmentItems: [SegmentTitle] = []
    @Published var goToBMIInputPage = false
    
    func fetchMenuItems() {
        self.genderSegmentItems = [
            SegmentTitle(title: "Male", icon: "male"),
            SegmentTitle(title: "Female", icon: "female")
        ]
    }
}
