//
//  Date+Ext.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 17.08.2024.
//

import Foundation

extension Date {
    // Method to format the date with a given format string
    func getFormattedDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    // Default formatter for short date style without time
    func getShortDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    static func date(from string: String, format: String) -> Date? {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = format
           return dateFormatter.date(from: string)
       }
}


