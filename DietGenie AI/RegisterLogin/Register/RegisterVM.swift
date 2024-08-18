//
//  RegisterVM.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import Foundation

class RegisterVM: BaseViewModel {
    @Published var goToBMIInputPage = false
    @Published var menuPickerItems:[CUIDropdownItemModel] = []
    
    func fetchMenuItems() {
        self.menuPickerItems = [
            CUIDropdownItemModel(id: "0", icon: "male", text: "Male", hasArrow: false),
            CUIDropdownItemModel(id: "1", icon: "female", text: "Female", hasArrow: false)
        ]
    }
}
