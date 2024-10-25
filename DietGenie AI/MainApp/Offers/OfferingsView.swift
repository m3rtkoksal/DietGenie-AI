//
//  OfferingsView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 25.10.2024.
//

import SwiftUI

struct OfferingsView: View {
    @StateObject private var viewModel = OfferingsVM()

    var body: some View {
        VStack {
            Text("Purchase Plans")
                .font(.largeTitle)
                .padding()

            if viewModel.offerings.isEmpty {
                Text("Loading offerings...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                ForEach(viewModel.offerings, id: \.self) { product in
                    CUIOfferingElement(
                        title: product.localizedTitle,
                        productId: product.productIdentifier,
                        description: product.localizedDescription,
                        price: String(describing: product.price),
                        purchaseAction: { productId in
                            viewModel.purchaseProduct(withId: productId)
                        }
                    )
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchOfferings() // Fetch offerings when the view appears
        }
    }
}
