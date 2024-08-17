//
//  InputViewModel.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import Foundation
import SwiftUI
import PhotosUI
import CoreTransferable
import HealthKit

class InputViewModel: BaseViewModel {
    @Published var goToProfileDetail = false
    @Published var goToSettings = false
    @Published var goToCampaigns = false
    @Published var goToHelp = false
    @Published var menuPickerItems:[CUIDropdownItemModel] = []
    @Published var genderSegmentItems: [SegmentTitle] = []
    @Published var purposeSegmentItems: [SegmentTitle] = []
    @Published var goToGenderInputPage = false 
    @Published var goToPurposeInputPage = false
    @Published var goToBMIInputPage = false
    @Published var goToRequestPage = false
    @Published var goToDietProgramView = false
    @Published var goToSelectInputView = false
    @Published var goToRegisterView = false
    @Published var goToPasswordReset = false
    
    func fetchMenuItems() {
        self.menuPickerItems = [
            CUIDropdownItemModel(id: "0", icon: "male", text: "Male", hasArrow: false),
            CUIDropdownItemModel(id: "1", icon: "female", text: "Female", hasArrow: false)
        ]
        self.genderSegmentItems = [
           SegmentTitle(title: "Male", icon: "male"),
           SegmentTitle(title: "Female", icon: "female")
        ]
        self.purposeSegmentItems = [
            SegmentTitle(title: "Fat Loss", icon: ""),
            SegmentTitle(title: "Muscle Gain", icon: ""),
            SegmentTitle(title: "Fat Gain", icon: ""),
        ]
    }
}


