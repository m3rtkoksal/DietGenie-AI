//
//  Font+Ext.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

extension Font {
    enum RobotoFont {
        case thin           // weight: 100
        case thinItalic
        case light          // weight: 300
        case lightItalic
        case regular        // weight: 400
        case medium         // weight: 500
        case mediumItalic
        case bold           // weight: 700
        case boldItalic
        case black
        case blackItalic
        case italic
        case custom(String)
        
        var value: String {
            switch self {
            case .thin:
                return "Roboto-Thin"
            case .thinItalic:
                return "Roboto-ThinItalic"
            case .light:
                return "Roboto-Light"
            case .lightItalic:
                return "Roboto-LightItalic"
            case .regular:
                return "Roboto-Regular"
            case .medium:
                return "Roboto-Medium"
            case .mediumItalic:
                return "Roboto-MediumItalic"
            case .bold:
                return "Roboto-Bold"
            case .boldItalic:
                return "Roboto-BoldItalic"
            case .black:
                return "Roboto-Black"
            case .blackItalic:
                return "Roboto-BlackItalic"
            case .italic:
                return "Roboto-Italic"
            case .custom(let name):
                return name
            }
        }
    }
    
    static func roboto(_ type: RobotoFont, size: CGFloat = 24) -> Font {
        .custom(type.value, size: size)
    }
    
    static func roboto(_ type: RobotoFont, size: CGFloat = 24) -> UIFont {
        return UIFont(name: type.value, size: size) ?? .systemFont(ofSize: size)
    }
    
    
    
    public enum PoppinsFont {
        case thin           // weight: 100
        case thinItalic
        case light          // weight: 300
        case lightItalic
        case regular        // weight: 400
        case medium         // weight: 500
        case mediumItalic
        case semiBold       // weight: 600
        case bold           // weight: 700
        case boldItalic
        case black
        case blackItalic
        case italic
        case custom(String)
        
        var value: String {
            switch self {
            case .thin:
                return "Poppins-Thin"
            case .thinItalic:
                return "Poppins-ThinItalic"
            case .light:
                return "Poppins-Light"
            case .lightItalic:
                return "Poppins-LightItalic"
            case .regular:
                return "Poppins-Regular"
            case .medium:
                return "Poppins-Medium"
            case .mediumItalic:
                return "Poppins-MediumItalic"
            case .semiBold:
                return "Poppins-SemiBold"
            case .bold:
                return "Poppins-Bold"
            case .boldItalic:
                return "Poppins-BoldItalic"
            case .black:
                return "Poppins-Black"
            case .blackItalic:
                return "Poppins-BlackItalic"
            case .italic:
                return "Poppins-Italic"
            case .custom(let name):
                return name
            }
        }
    }
    
    //    New Font For New Design
    static let heading1 = custom(PoppinsFont.semiBold.value, size: 32)
    static let heading2 = custom(PoppinsFont.semiBold.value, size: 24)
    static let heading3 = custom(PoppinsFont.semiBold.value, size: 20)
    static let heading4 = custom(PoppinsFont.semiBold.value, size: 16)
    static let heading5 = custom(PoppinsFont.medium.value, size: 24)
    static let heading6 = custom(PoppinsFont.medium.value, size: 20)
    static let subtext1 = custom(PoppinsFont.regular.value, size: 20)
    static let subtext2 = custom(PoppinsFont.medium.value, size: 16)
    static let subtext3 = custom(PoppinsFont.regular.value, size: 16)
    static let subtext4 = custom(PoppinsFont.regular.value, size: 14)
    static let subtext5 = custom(PoppinsFont.medium.value, size: 12)
    static let subtext6 = custom(PoppinsFont.regular.value, size: 12)
    static let subtext7 = custom(PoppinsFont.regular.value, size: 13)

    
    static func poppins(_ type: PoppinsFont, size: CGFloat = 24) -> Font {
        .custom(type.value, size: size)
    }
    
    static func poppins(_ type: PoppinsFont, size: CGFloat = 24) -> UIFont {
        UIFont(name: type.value, size: size) ?? .systemFont(ofSize: size)
    }
    
    static func poppinsUIFont(_ type: PoppinsFont, size: CGFloat = 24) -> UIFont {
        UIFont(name: type.value, size: size) ?? .systemFont(ofSize: size)
    }
}


extension UIFont {
    static let heading1 = Font.poppinsUIFont(.semiBold, size: 32)
    static let heading2 = Font.poppinsUIFont(.semiBold, size: 24)
    static let heading3 = Font.poppinsUIFont(.semiBold, size: 20)
    static let heading4 = Font.poppinsUIFont(.semiBold, size: 16)
    static let heading5 = Font.poppinsUIFont(.medium, size: 24)
    static let heading6 = Font.poppinsUIFont(.medium, size: 20)
    static let subtext1 = Font.poppinsUIFont(.regular, size: 20)
    static let subtext2 = Font.poppinsUIFont(.medium, size: 16)
    static let subtext3 = Font.poppinsUIFont(.regular, size: 16)
    static let subtext4 = Font.poppinsUIFont(.regular, size: 14)
    static let subtext5 = Font.poppinsUIFont(.medium, size: 12)
    static let subtext6 = Font.poppinsUIFont(.regular, size: 12)
}

