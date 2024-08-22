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
                    Text(title)
                        .font(.montserrat(.medium, size: 14))
                        .foregroundColor(.textColorsNeutral)
                }else {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.montserrat(.medium, size: 14))
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
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .frame(height: 50)
            .background(Color.white)
            .cornerRadius(38)
            .overlay(
                RoundedRectangle(cornerRadius: 38)
                    .strokeBorder(isExpanded ? Color.lightPurple : Color.lightGray200, lineWidth: 0.4)
            )
            .shadow(color: Color(red: 0.51, green: 0.74, blue: 0.62, opacity: 0.3), radius: 20, x: 0, y: 0)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 33)
    }
}

struct CUIDropdownField_Previews: PreviewProvider {
    static var previews: some View {
        CUIDropdownField(
            title: "Title",
            isExpanded: .constant(false),
            choosenItem: .constant(CUIDropdownItemModel(icon: "", text: ""))
        )
       
    }
}
