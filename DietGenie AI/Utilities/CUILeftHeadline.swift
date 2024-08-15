//
//  CUILeftHeadline.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

enum HeadLineStyleType{
    case red
    case purple
    case solidDarkPurple
    
    var titleColor: Color{
        switch self {
        case .red:
            return .red
        case .purple:
            return .textColorsPrimary
        case .solidDarkPurple:
            return .solidDarkPurple
        }
    }
    var subtitleColor: Color{
        switch self {
        case .red:
            return .lightGray100
        case .purple:
            return .textColorsPrimary
        case .solidDarkPurple:
            return .solidDarkPurple
        }
    }
}

struct CUILeftHeadline: View {
    
    var title: String
    var subtitle: String
    var style: HeadLineStyleType
    var bottomPadding: CGFloat?

    var body: some View {
        VStack(spacing: 0){
            HStack {
                Text(title)
                    .foregroundColor(style.titleColor)
                    .font(.heading1)
                Spacer()
            }.padding(.top, 24)
            HStack {
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .foregroundColor(style.subtitleColor)
                        .font(.subtext4)
                        .multilineTextAlignment(.leading)
                        .padding(.top,24)
                    Spacer()
                }
            }.padding(.bottom, bottomPadding ?? 40)
        }
        .padding(.horizontal, 16)
    }
}

struct CUIHeadline_Previews: PreviewProvider {
    static var previews: some View {
        CUILeftHeadline(title: "Title Title", subtitle: "asdasdasd asd asd asd asd asd asd asd asd asd asd asd asd asd asdasdasdasdasdasdasdasdasdasdasd", style: .purple)
    }
}
