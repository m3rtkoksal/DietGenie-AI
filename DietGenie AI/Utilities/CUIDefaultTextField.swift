//
//  CUIDefaultTextField.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

struct CUIDefaultTextField: View {
    @Binding var text: String
    var placeholder: String
    var fontColor: Color
    
    var body: some View {
        HStack {
            TextField("", text: $text)
                .placeholder(when: text.isEmpty, placeholder: {
                    Text(placeholder)
                        .foregroundColor(.solidGray)
                        .font(.montserrat(.medium, size: 14))
                })
                .font(.montserrat(.medium, size: 14))
                .foregroundColor(fontColor)
                .disableAutocorrection(true)
                .padding(.horizontal, 10)
            Spacer()
        }
    }
}

