//
//  OfferingsVM.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 25.10.2024.
//

import Foundation
import RevenueCat
import StoreKit
import FirebaseAuth

class OfferingsVM: BaseViewModel {
    @Published var offerings: [StoreProduct] = []
    
    func fetchOfferings() {
        Purchases.shared.getOfferings { (offerings, error) in
            if let error = error {
                print("Error fetching offerings: \(error.localizedDescription)")
                return
            }
            
            // Assuming you have an offering that contains the products
            if let offering = offerings?.current {
                self.offerings = offering.availablePackages.compactMap { package in
                    package.storeProduct // Extracting the StoreProduct
                }
            }
        }
    }
    
    func purchaseProduct(withId productId: String) {
        Purchases.shared.getProducts([productId]) { (products) in
            
            // Check if products are available
            if let product = products.first {
                // Proceed with purchasing the product
                self.purchaseProduct(product)
            } else {
                print("No products found.")
            }
        }
    }
    
    private func purchaseProduct(_ product: StoreProduct) {
        Purchases.shared.purchase(product: product) { (transaction, customerInfo, error, userCancelled) in
            if let error = error {
                print("Error purchasing product: \(error.localizedDescription)")
                return
            }

            if userCancelled {
                print("User cancelled the purchase.")
                return
            }

            if let transaction = transaction {
                // Successfully purchased
                print("Successfully purchased: \(transaction.productIdentifier)")

                // Fetch customer info to check entitlement
                Purchases.shared.getCustomerInfo { (customerInfo, error) in
                    if let error = error {
                        print("Error fetching customer info: \(error.localizedDescription)")
                        return
                    }

                    if let customerInfo = customerInfo {
                        // Check if the user has the premium entitlement
                        if customerInfo.entitlements.all["<your_entitlement_id>"]?.isActive == true {
                            // User is "premium"
                            self.makePurchase(product)
                        }
                    } else {
                        print("Customer info is nil.")
                    }
                }
            }
        }
    }
    
    private func makePurchase(_ product: StoreProduct) {
        Purchases.shared.purchase(product: product) { (transaction, info, error, userCancelled) in
            if let error = error {
                print("Error purchasing product: \(error.localizedDescription)")
                return
            }
            
            if userCancelled {
                print("User cancelled the purchase.")
                return
            }
            
            print("Successfully purchased: \(product.productIdentifier)")
            // Handle post-purchase logic
        }
    }
}
