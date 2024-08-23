//
//  CUILeftHeadline.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

enum HeadLineStyleType{
    case black
    case purple
    case solidDarkPurple
    
    var titleColor: Color{
        switch self {
        case .black:
            return .black
        case .purple:
            return .textColorsPrimary
        case .solidDarkPurple:
            return .solidDarkPurple
        }
    }
    var subtitleColor: Color{
        switch self {
        case .black:
            return .black
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
                    .font(.montserrat(.bold, size: 24))
                Spacer()
            }
            .padding(.top, 24)
            .padding(.trailing,33)
            HStack {
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .foregroundColor(style.subtitleColor)
                        .font(.montserrat(.medium, size: 14))
                        .multilineTextAlignment(.leading)
                        .padding(.top,10)
                    Spacer()
                }
            }
            .padding(.bottom, bottomPadding ?? 40)
            .padding(.trailing,33)
        }
        .padding(.leading, 33)
    }
}

struct CUIHeadline_Previews: PreviewProvider {
    static var previews: some View {
        CUILeftHeadline(title: "Title Title", subtitle: "asdasdasd asd asd asd asd asd asd asd asd asd asd asd asd asd asdasdasdasdasdasdasdasdasdasdasd", style: .purple)
    }
}
