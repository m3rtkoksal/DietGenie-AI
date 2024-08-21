//
//  CustomEllipseShape.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 19.08.2024.
//

import SwiftUI

struct CustomEllipseShape: Shape {
    var width: CGFloat
    var height: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let ellipseRect = CGRect(
            x: rect.midX - width / 2,
            y: rect.midY - height / 2,
            width: width,
            height: height
        )
        path.addEllipse(in: ellipseRect)
        return path
    }
}
