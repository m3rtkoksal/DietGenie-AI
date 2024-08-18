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
                                .font(.poppins(.regular, size: 16))
                        })
                        .font(.poppins(.regular, size: 16))
                        .padding(.leading, 10)
                        .padding(.trailing, 3)
                        .frame(height: 50)
                        .frame(maxWidth: UIScreen.screenWidth / 1.1)
                } else {
                    TextField(placeholder, text: $text)
                        .foregroundColor(.solidGray)
                        .font(.poppins(.regular, size: 16))
                        .padding(.leading, 10)
                        .frame(height: 50)
                        .frame(maxWidth: UIScreen.screenWidth / 1.1)
                }
                
                Button(action: {
                    isSecureField.toggle()
                }) {
                    Image(systemName: isSecureField ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
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

