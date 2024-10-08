//
//  UserInputModel.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//
import SwiftUI
import Combine
import HealthKit
import FirebaseCore

class UserInputModel: ObservableObject {
    @Published var userId: String?
    @Published var firstName: String?
    @Published var lastName: String?
    @Published var email: String?
    @Published var activeEnergy: Double?
    @Published var restingEnergy: Double?
    @Published var bodyFatPercentage: Double?
    @Published var leanBodyMass: Double?
    @Published var weight: Double?
    @Published var height: Double?
    @Published var gender: HKBiologicalSex?
    @Published var birthday: String?
    @Published var activity: String?
    @Published var purpose: String?
    @Published var dietPlans: [DietPlan] = []
}

struct DietPlan: Identifiable, Codable {
    var id: String?          // Document ID
    var createdAt: Date?     // Optional if you need to use this field
    var meals: [String]
    var userId: String
}
