//
//  CUIProgressView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 22.08.2024.
//

import SwiftUI

struct CUIProgressView: View {
    let progressCount: Int
    let currentProgress: Int
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(Array(1..<progressCount+1), id: \.self) { index in
                Capsule()
                    .fill(index <= currentProgress ? Color.topGreen : Color.progressBarPassive)
                    .frame(width: UIScreen.screenWidth * 0.7 / CGFloat((progressCount+1)), height: 4)
                    .animation(.default)
                    .shadow(color: Color.black.opacity(0.10), radius: 4, x: 0, y: 4)
            }
        }
    }
}

#Preview {
    CUIProgressView(progressCount: 4, currentProgress: 3)
}
