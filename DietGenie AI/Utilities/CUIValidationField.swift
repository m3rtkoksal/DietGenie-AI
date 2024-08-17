//
//  CUIValidationField.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI
import Combine

struct CUIValidationField: View {
    
    var placeholder: String
    var prompt: String
    var willShowPrompt: Bool = true
    @Binding var text: String
    @Binding var isCriteriaValid: Bool
    @Binding var isNotValid: Bool
    @Binding var showPrompt: Bool
    var style: UIKeyboardType
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                CUIDefaultTextField(
                    text: $text,
                    placeholder: placeholder,
                    fontColor: .teal)
                .keyboardType(style)
                .padding(.leading, 3)
                .frame(height: 50)
                .frame(maxWidth: UIScreen.screenWidth / 1.1)
            }
            .onChange(of: text) { newValue in
                isCriteriaValid = false
                isNotValid = false
                showPrompt = false
            }
            .frame(maxWidth: UIScreen.screenWidth / 1.1)
            .background(Color.otherBlack)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(isNotValid ? Color.red : .lightGray200, lineWidth: 1)
            )
            
            
            if  showPrompt && willShowPrompt {
                Text(prompt)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.footnote)
                    .foregroundColor(Color.red)
            }
        }.padding(.vertical, 5)
        
    }
}
