//
//  Color+Ext.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//
import SwiftUI
import UIKit

extension Color {
    static let CEFEFEF = Color(hex: "#EFEFEF") ?? Color("CEFEFEF")
    static let C753BBD = Color(hex: "#753BBD") ?? Color("C753BBD")
    static let C232224 = Color(hex: "#232224") ?? Color("C232224")
    static let C45BCF1 = Color(hex: "#45BCF1") ?? Color("C45BCF1")
    static let CFFFFFF = Color(hex: "#FFFFFF") ?? Color("CFFFFFF")
    static let CCCCCCC = Color(hex: "#CCCCCC") ?? Color("CCCCCCC")
    static let C7004B9 = Color(hex: "#7004B9") ?? Color("C7004B9")
    static let C999999 = Color(hex: "#999999") ?? Color("C999999")
    static let C666666 = Color(hex: "#666666") ?? Color("C666666")
    static let C007D0D = Color(hex: "#007D0D") ?? Color("C007D0D")
    static let CD00100 = Color(hex: "#D00100") ?? Color("CD00100")
    static let CD9D9D9 = Color(hex: "#D9D9D9") ?? Color("CD9D9D9")
    static let CEAEAEA = Color(hex: "#EAEAEA") ?? Color("CEAEAEA")
    static let C5F259F = Color(hex: "#5F259F") ?? Color("C5F259F")
    static let C65428A = Color(hex: "#65428A") ?? Color("C65428A")
    static let C8031A7 = Color(hex: "#8031A7") ?? Color("C8031A7")
    static let C87189D = Color(hex: "#87189D") ?? Color("C87189D")
    static let C9B26B6 = Color(hex: "#9B26B6") ?? Color("C9B26B6")
    static let C1C1B1F = Color(hex: "#1C1B1F") ?? Color("C1C1B1F")
    static let CFCFDFC = Color(hex: "#FCFDFC") ?? Color("CFCFDFC")
    static let C9C88EB = Color(hex: "#9C88EB") ?? Color("C9C88EB")
    static let CF5F5F5 = Color(hex: "#F5F5F5") ?? Color("CF5F5F5")
    static let C606164 = Color(hex: "#606164") ?? Color("C606164")
    static let CEDE4F4 = Color(hex: "#EDE4F4") ?? Color("CEDE4F4")
    static let CF6F7F6 = Color(hex: "#F6F7F6") ?? Color("CF6F7F6")
    static let C727272 = Color(hex: "#727272") ?? Color("C727272")
    static let C590049 = Color(hex: "#590049") ?? Color("C590049")
    static let C53005C = Color(hex: "#53005C") ?? Color("C53005C")
    static let C1A0D39 = Color(hex: "#1A0D39") ?? Color("C1A0D39")
    static let C00C620 = Color(hex: "#00C620") ?? Color("C00C620")
    static let C000000 = Color(hex: "#000000") ?? Color("C000000")
    static let CFF0000 = Color(hex: "#CFF0000") ?? Color("CFF0000")
    static let C2BBD3B = Color(hex: "#2BBD3B") ?? Color("C2BBD3B")
    static let C101828 = Color(hex: "#101828") ?? Color("C101828")
    static let C583387 = Color(hex: "#583387") ?? Color("C583387")
    static let CA13AD2 = Color(hex: "#A13AD2") ?? Color("CA13AD2")
    static let C8B858D = Color(hex: "#8B858D") ?? Color("C8B858D")
    static let C351E52 = Color(hex: "#351E52") ?? Color("C351E52")
    static let CEBE9E7 = Color(hex: "#EBE9E7") ?? Color("CEBE9E7")
    static let CE6D9EC = Color(hex: "#E6D9EC") ?? Color("CE6D9EC")
    static let CF6EFFA = Color(hex: "#F6EFFA") ?? Color("#F6EFFA")
    
    //NEW DESIGN
    static let solidDarkPurple = Color(ColorScheme.solidDarkPurple)
    static let solidGray = Color(ColorScheme.solidGray)
    static let solidWhite = Color(ColorScheme.solidWhite)
    static let lightGray200 = Color(ColorScheme.lightGray200)
    static let lightGray100 = Color(ColorScheme.lightGray100)
    static let lightPurple = Color(ColorScheme.lightPurple)
    static let lightPurple50 = Color(ColorScheme.lightPurple50)
    static let lightPurple100 = Color(ColorScheme.lightPurple100)
    static let lightPurple200 = Color(ColorScheme.lightPurple200)
    static let topGreen = Color(ColorScheme.topGreen)
    static let bottomBlue = Color(ColorScheme.bottomBlue)
    static let lightTeal = Color(ColorScheme.lightTeal)
    static let otherPurple = Color(UIColor(named: "otherPurple") ?? UIColor.init(hex: "#9747FF"))
    static let progressBarPassive = Color(ColorScheme.progressBarPassive)
    static let cellBGGreen = Color(ColorScheme.cellBGGreen)

    //Text Colors
    static let textColorsPrimary = Color(ColorScheme.textColorsPrimary)
    static let textColorsNeutral = Color(ColorScheme.textColorsNeutral)
    static let otherBlack = Color(ColorScheme.otherBlack)  //Figmada isimlendirilmemiş
    static let otherGray = Color(ColorScheme.otherGray)  //Figmada isimlendirilmemiş
    static let menuBlack = Color(ColorScheme.menuBlack)  //Figmada isimlendirilmemiş

    var uiColor: UIColor {
        UIColor(self)
    }
    
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexValue = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexValue.hasPrefix("#") {
            hexValue.remove(at: hexValue.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
           
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }
}


