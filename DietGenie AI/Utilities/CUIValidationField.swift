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
                    fontColor: .textColorsNeutral)
                .keyboardType(style)
                .padding(.leading, 3)
                .frame(height: 50)
                .frame(maxWidth: UIScreen.screenWidth / 1.2)
            }
            .onChange(of: text) { newValue in
                isCriteriaValid = false
                isNotValid = false
                showPrompt = false
            }
            .frame(maxWidth: UIScreen.screenWidth / 1.2)
            .background(Color.white)
            .cornerRadius(38)
            .overlay(
                RoundedRectangle(cornerRadius: 38)
                    .strokeBorder(isNotValid ? Color.red : .lightGray200, lineWidth: 0.4)
            )
            .shadow(color: Color(red: 0.51, green: 0.74, blue: 0.62, opacity: 0.3), radius: 20, x: 0, y: 0)
            
            if  showPrompt && willShowPrompt {
                Text(prompt)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.footnote)
                    .foregroundColor(Color.red)
            }
        }.padding(.vertical, 5)
        
    }
}

struct CUIValidationField_Previews: PreviewProvider {
    @State static var text = ""
    @State static var isCriteriaValid = false
    @State static var isNotValid = false
    @State static var showPrompt = true

    static var previews: some View {
        ZStack {
            Color.lightTeal
            CUIValidationField(
                placeholder: "Enter text",
                prompt: "This is a validation prompt.",
                willShowPrompt: true,
                text: $text,
                isCriteriaValid: $isCriteriaValid,
                isNotValid: $isNotValid,
                showPrompt: $showPrompt,
                style: .default
            )
        }
      
        
        .previewLayout(.sizeThatFits)
    }
}
