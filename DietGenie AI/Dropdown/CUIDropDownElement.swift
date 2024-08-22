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
            Text(item.text)
                .font(.subtext4)
                .foregroundColor(choosenItem ? .lightPurple : .textColorsPrimary)
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
