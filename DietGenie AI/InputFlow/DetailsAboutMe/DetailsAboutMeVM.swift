//
//  BMIInputVM.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import SwiftUI
import HealthKit

class DetailsAboutMeVM: BaseViewModel {
    @Published var goToPurposeInputPage = false
    @Published var genderSegmentItems: [SegmentTitle] = []
    @Published var goToBMIInputPage = false
    @StateObject private var healthKitManager = HealthKitManager()
    @Published var dropdownTitle: String = "Select Height"
    @Published var lengthOptions: [CUIDropdownItemModel] = []
    
    func fetchMenuItems() {
        self.genderSegmentItems = [
            SegmentTitle(title: "Male", icon: "male"),
            SegmentTitle(title: "Female", icon: "female")
        ]
    }
    
    func genderStringToHKBiologicalSex(_ gender: String) -> HKBiologicalSex? {
        switch gender.lowercased() {
        case "male":
            return .male
        case "female":
            return .female
        case "other":
            return .other
        default:
            return nil
        }
    }
}

