//
//  CUIDropdownField.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//
import SwiftUI

struct CUIDropdownField: View {
    var title: String
    @Binding var isExpanded: Bool
    @Binding var choosenItem: CUIDropdownItemModel
    var isHiddenChangeText: Bool = false

    var body: some View {
        HStack {
                Button {
                    isExpanded.toggle()
                } label: {
                if !isExpanded && choosenItem.text.isEmpty {
                    Text(choosenItem.text.isEmpty ? title : choosenItem.text)
                        .font(.subtext4)
                        .foregroundColor(.textColorsNeutral)
                }else {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.subtext6)
                            .foregroundColor(.textColorsNeutral)
                        
                        Text(choosenItem.text.isEmpty ? "Select From Menu" : choosenItem.text)
                            .font(.subtext4)
                            .foregroundColor(.textColorsNeutral)
                    }
                }
                Spacer()
           
                Image(systemName: "chevron.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical)
        .frame(height: 48)
        .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(isExpanded ? Color.lightPurple : Color.lightGray200))
        .background(Color.clear)
    }
}

struct CUIDropdownField_Previews: PreviewProvider {
    static var previews: some View {
        CUIDropdownField(title: "Title", isExpanded: .constant(true), choosenItem: .constant(CUIDropdownItemModel(icon: "", text: "")))
    }
}

