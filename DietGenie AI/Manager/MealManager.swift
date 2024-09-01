//
//  MeanManager.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 1.09.2024.
//

import Foundation

class MealManager {
    static let shared = MealManager()
    private let selectedMealsKeyPrefix = "selectedMeals_"
    private let lastResetKey = "lastResetDate"
    
    // Save selected meals to UserDefaults
    func saveSelectedMeals(dietPlanId: String, selectedMeals: Set<String>) {
        let defaults = UserDefaults.standard
        defaults.set(Array(selectedMeals), forKey: "\(selectedMealsKeyPrefix)\(dietPlanId)")
    }
    
    // Load selected meals from UserDefaults
    func loadSelectedMeals(dietPlanId: String) -> Set<String> {
        let defaults = UserDefaults.standard
        if let savedMeals = defaults.array(forKey: "\(selectedMealsKeyPrefix)\(dietPlanId)") as? [String] {
            return Set(savedMeals)
        }
        return []
    }
    
    // Clean all selected meals
    func cleanAllSelectedMeals() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        for key in dictionary.keys {
            if key.hasPrefix(selectedMealsKeyPrefix) {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    // Check and clean selected meals daily
    func checkAndCleanDaily() {
        let defaults = UserDefaults.standard
        let now = Date()
        
        // Get the last reset date
        if let lastResetDate = defaults.object(forKey: lastResetKey) as? Date {
            // Check if the last reset was more than 24 hours ago
            if now.timeIntervalSince(lastResetDate) > 86400 {
                cleanAllSelectedMeals()
                defaults.set(now, forKey: lastResetKey)
            }
        } else {
            // If there's no record of the last reset, reset now
            cleanAllSelectedMeals()
            defaults.set(now, forKey: lastResetKey)
        }
    }
}

