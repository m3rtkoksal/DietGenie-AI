//
//  UserInputModel.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//
import SwiftUI
import Combine
import HealthKit

class UserInputModel: ObservableObject {
    @Published var activeEnergy: Double?
    @Published var restingEnergy: Double?
    @Published var bodyFatPercentage: Double?
    @Published var leanBodyMass: Double?
    @Published var weight: Double?
    @Published var height: Double?
    @Published var gender: HKBiologicalSex?
    @Published var age: Int?
    @Published var purpose: String?
}
