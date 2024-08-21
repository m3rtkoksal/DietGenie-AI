//
//  CUIButton.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

struct CUIButton: View {
    let image: String?
    let text: String
    let backgroundColor: Color
    let textColor: Color
    let action: () -> Void
    
    init(image: String? = nil, text: String, backgroundColor: Color = .topGreen, textColor: Color = .black, action: @escaping () -> Void) {
        self.image = image
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.action = action
    }
    
    var body: some View {
        Button(action: self.action) {
            HStack(spacing: 8) {
                if let imageName = image, !imageName.isEmpty {
                    Image(imageName)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                Text(text)
                    .font(.montserrat(.bold, size: 17))
                    .foregroundColor(textColor)
            }
            .padding()
            .frame(width: UIScreen.screenWidth / 1.2, height: 48, alignment: .center)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 38))
            .overlay(
                RoundedRectangle(cornerRadius: 38)
                    .stroke(Color.black, lineWidth: 1)
            )
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CUIButton(image: "backButton", text: "Yo", action: {})
}

#Preview {
    CUIButton(text: "Yo", action: {})
}
