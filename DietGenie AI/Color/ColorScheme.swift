//
//  ColorScheme.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import UIKit

//MARK: Colors for light dark mode
struct ColorScheme {
    static func color(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor.dynamicColor(light: light, dark: dark)
    }
    static var passionPlum: UIColor {
        return color(light: UIColor.init(hex: "#753BBD"), dark: UIColor.init(hex: "#753BBD"))
    }
    static var solidDarkPurple: UIColor {
        return color(light:UIColor.init(hex: "#351E52"),
                     dark: UIColor.init(hex: "#351E52"))
    }
    static var solidGray: UIColor {
        return color(light:UIColor.init(hex: "#8B858D"),
                     dark: UIColor.init(hex: "#8B858D"))
    }
    static var solidWhite: UIColor {
        return color(light:UIColor.init(hex: "#FFFFFF"),
                     dark: UIColor.init(hex: "#FFFFFF"))
    }
    static var lightGray200: UIColor {
        return color(light:UIColor.init(hex: "#EBE9E7"),
                     dark: UIColor.init(hex: "#EBE9E7"))
    }
    
    static var lightGray100: UIColor {
        return color(light:UIColor.init(hex: "#F3F2F1"),
                     dark: UIColor.init(hex: "#F3F2F1"))
    }
    
    static var lightPurple: UIColor {
        return color(light:UIColor.init(hex: "#A13AD2"),
                     dark: UIColor.init(hex: "#A13AD2"))
    }
    
    static var lightPurple50: UIColor {
        return color(light:UIColor.init(hex: "#F6EFFA"),
                     dark: UIColor.init(hex: "#F6EFFA"))
    }

    static var lightPurple100: UIColor {
        return color(light:UIColor.init(hex: "#E6D9EC"),
                     dark: UIColor.init(hex: "#E6D9EC"))
    }
        
    static var lightPurple200: UIColor {
        return color(light:UIColor.init(hex: "#AD9AC4"),
                     dark: UIColor.init(hex: "#AD9AC4"))
    }
    
    static var warningYellow: UIColor {
        return color(light:UIColor.init(hex: "#F7CF46"),
                     dark: UIColor.init(hex: "#F7CF46"))
    }
    
    static var darkPurple: UIColor {
        return color(light:UIColor.init(hex: "#583387"),
                     dark: UIColor.init(hex: "#583387"))
    }
    
    static var actionError: UIColor {
        return color(light:UIColor.init(hex: "#DC5252"),
                     dark: UIColor.init(hex: "#DC5252"))
    }
    
    static var actionWarning: UIColor {
        return color(light:UIColor.init(hex: "#EEAE39"),
                     dark: UIColor.init(hex: "#EEAE39"))
    }
    
    static var actionSuccess: UIColor {
        return color(light:UIColor.init(hex: "#5AC55A"),
                     dark: UIColor.init(hex: "#5AC55A"))
    }

    
    static var textColorsPrimary: UIColor {
        return color(light:UIColor.init(hex: "#351E52"),
                     dark: UIColor.init(hex: "#351E52"))
    }
    
    static var textColorsNeutral: UIColor {
        return color(light:UIColor.init(hex: "#8B858D"),
                     dark: UIColor.init(hex: "#8B858D"))
    }
    
    static var otherBlack: UIColor {
        return color(light:UIColor.init(hex: "#1D232E"),
                     dark: UIColor.init(hex: "#1D232E"))
    }
    
    static var otherGray: UIColor {
        return color(light:UIColor.init(hex: "#999999"),
                     dark: UIColor.init(hex: "#999999"))
    }
    
    static var menuBlack: UIColor {
        return color(light:UIColor.init(hex: "#351E52"),
                     dark: UIColor.init(hex: "#351E52"))
    }
    
    
    
}


