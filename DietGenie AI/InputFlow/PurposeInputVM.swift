//
//  PurposeInputVM.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import Foundation

class PurposeInputVM: BaseViewModel {
    
    @Published var purposeSegmentItems: [SegmentTitle] = []
    @Published var goToDietProgram = false
    
    func fetchSegmentItems() {
        self.purposeSegmentItems = [
            SegmentTitle(title: "Fat Loss", icon: ""),
            SegmentTitle(title: "Muscle Gain", icon: ""),
            SegmentTitle(title: "Fat Gain", icon: ""),
        ]
    }
}
