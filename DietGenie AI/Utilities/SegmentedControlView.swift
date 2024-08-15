//
//  SegmentedControlView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

struct SegmentTitle {
    let title: String
    let icon: String
}

struct SegmentedControlView: View {
    @Binding var selectedIndex: Int
    var titles: [SegmentTitle]
    
    private var segmentWidth: CGFloat {
        UIScreen.screenWidth * 0.9 / CGFloat(titles.count)
        }
    
    var body: some View {
        HStack {
            ForEach(0..<titles.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedIndex = index
                    }
                }) {
                    HStack {
                        if !titles[index].icon.isEmpty {
                            Image(titles[index].icon)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 50)
                        }
                        Text(titles[index].title)
                            .font(.subheadline) // Use appropriate font
                    }
                    .padding(.vertical, 10)
                    .frame(width: segmentWidth)
                    .foregroundColor(selectedIndex == index ? .red : .gray)
                    .background(selectedIndex == index ? Color.gray.opacity(0.2) : Color.clear)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
            .padding()
            .background(.clear)
            .cornerRadius(10)
            .frame(maxHeight: 50)
        
    }
}
