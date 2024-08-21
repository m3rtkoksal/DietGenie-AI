//
//  CUIDivider.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 20.08.2024.
//

import SwiftUI

struct CUIDivider: View {
    @State var title: String
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 0)
                .frame(height:1)
                .frame(width: UIScreen.screenWidth / 3.5)
                .foregroundColor(.C999999)
            Text(title)
                .font(.montserrat(.medium, size: 12))
                .foregroundColor(.C999999)
                .frame(width: UIScreen.screenWidth / 4)
            RoundedRectangle(cornerRadius: 0)
                .frame(height:1)
                .frame(width: UIScreen.screenWidth / 3.5)
                .foregroundColor(.C999999)
               
        }
    }
}

#Preview {
    CUIDivider(title: "Or Login with")
}
