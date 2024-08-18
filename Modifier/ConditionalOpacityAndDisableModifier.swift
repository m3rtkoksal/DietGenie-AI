//
//  ConditionalOpacityAndDisableModifier.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import SwiftUI

struct ConditionalOpacityAndDisableModifier: ViewModifier {
    let isEnabled: Bool
    
    init(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(isEnabled ? 1 : 0.3)
            .disabled(!isEnabled)
    }
}

extension View {
    func conditionalOpacityAndDisable(isEnabled: Bool) -> some View {
        self.modifier(ConditionalOpacityAndDisableModifier(isEnabled: isEnabled))
    }
}
