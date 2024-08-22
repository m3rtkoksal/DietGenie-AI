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
    var segmentTitle: String
    @Binding var selectedIndex: Int
    var segmentNames: [SegmentTitle]
    
    private var segmentWidth: CGFloat {
        UIScreen.screenWidth * 0.83 / CGFloat(segmentNames.count)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(segmentTitle)
                .font(.montserrat(.medium, size: 14))
            HStack(spacing: 1) {
                ForEach(0..<segmentNames.count, id: \.self) { index in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedIndex = index
                        }
                    }) {
                        HStack {
                            if !segmentNames[index].icon.isEmpty {
                                Image(segmentNames[index].icon)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 30)
                            }
                            Text(segmentNames[index].title)
                                .font(.subheadline) // Use appropriate font
                        }
                        .padding(.vertical, 10)
                        .frame(width: segmentWidth)
                        .foregroundColor(selectedIndex == index ? .black : .gray)
                        .background(selectedIndex == index ? Color.topGreen : Color.white)
                        .clipShape(
                            RoundedCorner(radius: index == 0 ? 38 : index == segmentNames.count - 1 ? 38 : 0,
                                          corners: index == 0 ? [.topLeft, .bottomLeft] : index == segmentNames.count - 1 ? [.topRight, .bottomRight] : [])
                        )
                        .overlay(
                            RoundedCorner(radius: index == 0 ? 38 : index == segmentNames.count - 1 ? 38 : 0,
                                          corners: index == 0 ? [.topLeft, .bottomLeft] : index == segmentNames.count - 1 ? [.topRight, .bottomRight] : [])
                                .stroke(selectedIndex == index ? Color.black : Color.clear, lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
            .background(.clear)
            .cornerRadius(10)
            .frame(maxHeight: 50)
            .shadow(color: Color(red: 0.51, green: 0.74, blue: 0.62, opacity: 0.3), radius: 20, x: 0, y: 0)
        }
    }
}

struct SegmentedControlView_Previews: PreviewProvider {
    @State static var selectedIndex = 0
    
    static var previews: some View {
        SegmentedControlView(
            segmentTitle: "Please select your gender", selectedIndex: $selectedIndex,
            segmentNames: [
                SegmentTitle(title: "Male", icon: "male"),
                SegmentTitle(title: "Female", icon: "female")
            ]
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
