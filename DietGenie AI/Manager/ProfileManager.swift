//
//  ProfileManager.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 25.08.2024.
//

import Foundation
import Combine
import UIKit
import SwiftUI

enum CustomerType: Int {
    public static var defaultDecoderValue: CustomerType = .none
    case anonim
    case yillik
    case none
}

final class ProfileManager: ObservableObject {
    static let shared = ProfileManager()
    @Published private(set) var user: UserProfileModel
    
    var userPublisher: AnyPublisher<UserProfileModel, Never> {
        $user.eraseToAnyPublisher()
    }
    
    private init() {
        user = UserProfileModel()
    }
    
    func setCustomerId(id: Int) {
        self.user.customerId = id
    }
    
    func setUserEmail(_ email: String) {
        self.user.email = email
    }
    func setWeight( _ weight: String) {
        self.user.weight = weight
    }
    func setHeight( _ height: String) {
        self.user.height = height
    }
    
    func setUserNames(firstName: String, middleName: String?, lastName: String) {
        self.user.firstName = firstName
        self.user.lastName = lastName
    }
    
    func setActiveEnergy(_ activeEnergy: String) {
        self.user.activeEnergy = activeEnergy
    }
    
    func setPassiveEnergy(_ passiveEnergy: String) {
        self.user.passiveEnergy = passiveEnergy
    }
    
    func setActivityLevel(_ activityLevel: String) {
        self.user.activityLevel = activityLevel
    }
    
    func setCustomer(type: CustomerType) {
        self.user.customerType = type
    }
    
    func setHasAddress(_ a: Bool){
        self.user.hasAddress = a
    }
    
    func setHasOccupation(_ o: Bool){
        self.user.hasOccupation = o
    }
    
    func setIsLoggedWithBiometric(_ v: Bool) {
        self.user.isLoggedInWithBiometric = v
    }
    /*
    func setProfilePicture(encryptedProfileImageString: String?) {
        if encryptedProfileImageString != nil {
            if let encryptedData = KeychainManager.shared.getDataFromKeychain(forKey: .profileImageData) {
                EncryptionManager.decryptData(encryptedData) { decryptedData in
                    if let decryptedData = decryptedData,
                       let image = UIImage(data: decryptedData) {
                        DispatchQueue.main.async {
                            self.user.profileImage = image
                            self.user.profileImageEmpty = false
                        }
                    } else {
                        print("Failed to decrypt or create UIImage from image data")
                    }
                }
            } else {
                print("Failed to load image from Keychain")
            }
        } else {
            if self.user.profileImage != nil {
                KeychainManager.shared.deleteDataFromKeychain(forkey: .profileImageData)
                self.user.profileImage = UIImage(named: "profile-circle")
                self.user.profileImageEmpty = true
            }
        }
    }
     */
    func setPhoneNumber(_ pn: String) {
        self.user.phoneNumber = pn
    }
    // Set IBAN
    func setUserIban(_ iban: String) {
        self.user.iban = iban
    }
    // Set Notification Count
    func setUserNotificationCount(_ count: Int) {
        self.user.notificationCount = count
    }
    
    func setUserIsLoggedIn(_ isLoggedIn: Bool) {
        self.user.isUserLoggedIn = isLoggedIn
    }
    
    func resetUser() {
        user = UserProfileModel()
    }
    
    func reduceNotificationCount() {
        if self.user.notificationCount > 0 {
            self.user.notificationCount -= 1
        }
    }
}

final class UserProfileModel: Equatable, ObservableObject {
    
    static func ==(lhs: UserProfileModel, rhs: UserProfileModel) -> Bool {
        // Define the logic for comparing two UserProfileModel instances here
        // You need to compare all relevant properties to determine equality
        return lhs.email == rhs.email && lhs.email == rhs.email // Add more properties as needed
    }
    
    var customerId: Int = 0
    var email: String = ""
    var firstName: String = ""
    var middleName: String = ""
    var lastName: String = ""
    var mainWalletId: Int?
    var mainPrefixId: Int?
    var weight: String = ""
    var height: String = ""
    var activeEnergy: String = ""
    var passiveEnergy: String = ""
    var activityLevel: String = ""
    var countryCode: Int = 0
    var customerType: CustomerType = .anonim
    var hasAddress: Bool = false
    var hasOccupation: Bool = false
    var isLoggedInWithBiometric = false
    var phoneNumber = ""
    var iban: String = ""
    @Published var notificationCount: Int = 0
    var isUserLoggedIn = false
    var isContracted: Bool {
        customerType == .yillik
    }
    
    var hasRequiredFieldForUpgrade: Bool {
        hasAddress && hasOccupation
    }
    
    var fullName: String {
        "\(firstName)\(middleName.isEmpty ? "" : " \(middleName)") \(lastName)"
    }
    
}

