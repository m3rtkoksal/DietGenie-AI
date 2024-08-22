//
//  HowActiveYouVM.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 22.08.2024.
//

import SwiftUI

class HowActiveYouVM: BaseViewModel {
    @Published var goToPurpose = false
    @Published var activityItems: [ActivityItem] = []
    
    func fetchActivityItems() {
        self.activityItems = [
            ActivityItem(title: "Not very active", subtitle: "Spend most of the day sitting (e.g. desk job, bank teller) "),
            ActivityItem(title: "Lightly active", subtitle: "Spend a good part of the day on your feet  (e.g. teacher, salesperson)"),
            ActivityItem(title: "Active", subtitle: "Spend a good part of the day doing some physical activity (e.g. waiter, postal carrier)"),
            ActivityItem(title: "Very active", subtitle: "Spend most of the day doing heavy physical activity (e.g. construction worker, carpenter)")
        ]
    }
}
    
