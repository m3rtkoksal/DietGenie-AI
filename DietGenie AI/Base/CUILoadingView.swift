//
//  CUILoadingView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 14.08.2024.
//

import SwiftUI

struct CUILoadingView: View {
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.2)
                .ignoresSafeArea()

            // Rotating Circle
            Circle()
                .trim(from: 0.0, to: 0.7)
                .stroke(Color.white, lineWidth: 5)
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(rotationAngle))
                .onAppear {
                    // Rotate the circle indefinitely
                    withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                        rotationAngle = 360
                    }
                }
        }
    }
}

// Preview for the loading view
struct CUILoadingView_Previews: PreviewProvider {
    static var previews: some View {
        CUILoadingView()
    }
}
