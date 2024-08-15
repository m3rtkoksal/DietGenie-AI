//
//  CUIDropDownElement.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

struct CUIDropdownElement: View {
    var item: CUIDropdownItemModel
    var choosenItem: Bool
    
    var body: some View {
        HStack {
            if let iconName = item.icon {
                if !iconName.isEmpty {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(choosenItem ? .lightPurple : .textColorsPrimary)
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 16)
                    
                }
            }
            
            Text(item.text)
                .font(.subtext4)
                .foregroundColor(choosenItem ? .lightPurple : .textColorsPrimary)
                
            Spacer()
            if item.hasArrow.unsafelyUnwrapped {
                Image("simple-arrow-right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                
            }
        }
        .background(Color.solidWhite)
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct CUIDropdownElement_Previews: PreviewProvider {
    static var previews: some View {
        CUIDropdownElement(item: CUIDropdownItemModel(icon: "", text: "Lorem Ipsum"), choosenItem: false)
    }
}
