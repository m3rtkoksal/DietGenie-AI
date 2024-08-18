//
//  TabButton.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import SwiftUI

struct TabButton: View {
    var title: String
    @Binding var selectedTab: String
    var animation: Namespace.ID
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()){selectedTab = title}
        }, label: {
            VStack(alignment: .leading, spacing: 3, content: {
                Text(title)
                    .fontWeight(.bold)
                    .foregroundColor(selectedTab == title ? .black : .gray)
                if selectedTab == title {
                    Capsule()
                        .fill(Color.black)
                        .frame(width: 30, height: 4)
                        .matchedGeometryEffect(id: "Tab", in: animation)
                }
            })
            .padding(.leading, 20)
        })
    }
}

