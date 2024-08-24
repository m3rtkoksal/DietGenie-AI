//
//  HealthKitPermissionVM.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 21.08.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Combine

class HealthKitPermissionVM: BaseViewModel {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userInputModel: UserInputModel
    @StateObject private var healthKitManager = HealthKitManager()
    @Published var goToBMIInputPage = false
    @Published var menuPickerItems:[CUIDropdownItemModel] = []
    @Published var goToHealthPermission = false
    @Published var goToLogin = false
    @Published var goToPrivacyPolicy = false
    private let db = Firestore.firestore()
    
    func fetchMenuItems() {
        self.menuPickerItems = [
            CUIDropdownItemModel(id: "0", icon: "male", text: "Male", hasArrow: false),
            CUIDropdownItemModel(id: "1", icon: "female", text: "Female", hasArrow: false)
        ]
    }
}
