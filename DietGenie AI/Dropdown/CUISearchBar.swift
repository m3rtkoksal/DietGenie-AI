//
//  CUISearchBar.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//
import SwiftUI

struct CUISearchBar: View {
    @Binding var text: String
    var placeHolder: String?
    
    var body: some View {
            HStack (spacing: 16){
                if text.isEmpty {
                    Image("ico_search")
                        .frame(width: 20, height: 20)
                } else {
                    Image("left-back")
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            text.removeLast()
                        }
                }
                TextField(placeHolder ?? "", text: $text)
                    .disableAutocorrection(true)
                    .font(.subtext3)
                    .foregroundColor(.textColorsNeutral)
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40, alignment: .leading)
                Image("coachingCloseIcon").hiddenConditionally(isHidden: text.isEmpty)
                    .onTapGesture {
                        text = ""
                    }
            }.padding(.horizontal)
                .background(Color.solidWhite)
                .overlay(RoundedRectangle(cornerRadius: 32).strokeBorder(Color.lightPurple200))
    }
}


