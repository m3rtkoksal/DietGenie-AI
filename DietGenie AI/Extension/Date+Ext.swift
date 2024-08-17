//
//  Date+Ext.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 17.08.2024.
//

import Foundation

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

