//
//  DietPlanElement.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import SwiftUI

struct DietPlanElement: View {
    var date: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 38)
                .stroke(Color.progressBarPassive, lineWidth: 1)
                .background(Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 38))
            HStack {
                Text(date)
                    .foregroundStyle(.black)
                    .font(.montserrat(.semiBold, size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 10, height: 10)
            }
            .padding(.horizontal)
        }
        .background(Color.clear)
        .frame(height: 46)
        .padding(.horizontal, 33)
    }
}

#Preview {
    DietPlanElement(date: "13.06.24")
}
