//
//  CUIPasswordValidationField.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import SwiftUI

struct CUIPasswordValidationField: View {
    
    var placeholder: String
    var prompt: String
    var willShowPrompt: Bool = true
    @Binding var text: String
    @Binding var isCriteriaValid: Bool
    @Binding var isNotValid: Bool
    @Binding var showPrompt: Bool
    
    @State private var isSecureField: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if isSecureField {
                    SecureField("", text: $text)
                        .placeholder(when: text.isEmpty, placeholder: {
                            Text(placeholder)
                                .foregroundColor(.solidGray)
                                .font(.montserrat(.medium, size: 14))
                        })
                        .font(.montserrat(.medium, size: 14))
                        .foregroundColor(.black)
                        .padding(.leading, 16)
                        .padding(.trailing, 3)
                        .frame(height: 50)
                        .frame(maxWidth: UIScreen.screenWidth / 1.2)
                } else {
                    TextField(placeholder, text: $text)
                        .foregroundColor(.black)
                        .font(.montserrat(.medium, size: 14))
                        .padding(.leading, 10)
                        .frame(height: 50)
                        .frame(maxWidth: UIScreen.screenWidth / 1.2)
                }
                
                Button(action: {
                    isSecureField.toggle()
                }) {
                    Image(systemName: isSecureField ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 16)
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
            
            if showPrompt && willShowPrompt {
                Text(prompt)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.footnote)
                    .foregroundColor(Color.red)
            }
        }
        .padding(.vertical, 5)
    }
}

