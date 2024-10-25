//
//  CUIPersonalInfoElement.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 25.08.2024.
//

import SwiftUI

struct CUIPersonalInfoElement: View {
    let title: String
    let description: String
    let isTextLightPurple: Bool
    let buttonIcon: String?
    let buttonAction: () -> Void
    
    init(
            title: String,
            description: String,
            isTextLightPurple: Bool = false,
            buttonIcon: String?,
            buttonAction: @escaping () -> Void
        ) {
            self.title = title
            self.description = description
            self.isTextLightPurple = isTextLightPurple
            self.buttonIcon = buttonIcon
            self.buttonAction = buttonAction
        }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: buttonAction) {
                HStack {
                    Text(title)
                        .font(.subtext3)
                        .foregroundColor(.solidGray)
                    Spacer()
                    Text(description)
                        .font(.subtext3)
                        .foregroundColor(isTextLightPurple ? .lightPurple : .solidDarkPurple)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
//                        .minimumScaleFactor(0.5)
                    if let icon = buttonIcon {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                    }
                }
                .padding(.vertical, 8)
            }
            
            Divider()
                .padding(.top, 8)
        }
        .padding(.horizontal)
    }
}

struct CUIPersonalElement_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CUIPersonalInfoElement(
                title: "Müşteri ID",
                description: "The White House The White House",
                buttonIcon: "pasteGoIcon",
                buttonAction: { }
            )
            CUIPersonalInfoElement(
                title: "Müşteri ID",
                description: "The White House",
                buttonIcon: "pasteGoIcon",
                buttonAction: { }
            )
            CUIPersonalInfoElement(
                title: "Müşteri ID",
                description: "The White House",
                buttonIcon: nil,
                buttonAction: { }
            )
        }
    }
}
