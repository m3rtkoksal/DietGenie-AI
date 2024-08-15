//
//  String+Ext.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import Foundation

extension String {
    func trimmingAllSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return components(separatedBy: characterSet).joined()
    }
}
