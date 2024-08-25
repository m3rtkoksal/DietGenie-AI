//
//  DietPlanDetailVM.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 25.08.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DietPlanDetailVM: BaseViewModel {
    @Published var mealItems: [String] = []
    @Published var mealIcons: [String] = []
    private let db = Firestore.firestore()
    private let userId = Auth.auth().currentUser?.uid

    func getMealIcons() {
        self.mealIcons = [
            "pan_egg",
            "banana_apple",
            "green-salad",
            "sandwich",
            "meat",
            "falafel"
        ]
    }

    func saveSelectedMeals(dietPlanId: String, selectedMeals: Set<String>, completion: @escaping (Error?) -> Void) {
        guard let userId = userId else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }

        let data = Array(selectedMeals)
        db.collection("users").document(userId).collection("dietPlans").document(dietPlanId).updateData([
            "selectedMeals": data
        ]) { error in
            completion(error)
        }
    }

    func loadSelectedMeals(dietPlanId: String, completion: @escaping (Set<String>?, Error?) -> Void) {
        guard let userId = userId else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }

        db.collection("users").document(userId).collection("dietPlans").document(dietPlanId).getDocument { document, error in
            if let error = error {
                completion(nil, error)
            } else if let document = document, document.exists, let data = document.data(), let selectedMeals = data["selectedMeals"] as? [String] {
                completion(Set(selectedMeals), nil)
            } else {
                completion(Set<String>(), nil) // No data found
            }
        }
    }
}
