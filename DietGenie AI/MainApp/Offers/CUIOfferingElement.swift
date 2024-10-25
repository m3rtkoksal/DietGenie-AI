//
//  CUIOfferingElement.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 25.10.2024.
//

import SwiftUI

struct CUIOfferingElement: View, Identifiable {
    let id = UUID()
    let title: String
    let productId: String
    let description: String
    let price: String
    let purchaseAction: (String) -> Void
    
    var body: some View {
        VStack {
            Text(title) // Use title directly instead of plan.title
                .font(.headline)
            Text(description) // Use description directly instead of plan.description
                .font(.subheadline)
            Text(price) // Use price directly instead of plan.price
                .font(.title)
                .foregroundColor(.green)
            Button(action: {
                purchaseAction(productId) // Call the purchase action with productId
            }) {
                Text("Purchase")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .border(Color.gray.opacity(0.5), width: 1)
    }
}
