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
        HStack {
            Text(date)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding(.horizontal)
        .foregroundColor(.lightGray200)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.teal, lineWidth: 2)
                .frame(width: UIScreen.screenWidth * 0.9))
        
        
    }
}

#Preview {
    DietPlanElement(date: "13.06,24")
}
