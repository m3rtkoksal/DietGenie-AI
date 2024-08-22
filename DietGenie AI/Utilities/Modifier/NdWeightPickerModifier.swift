//
//  NdWeightPickerModifier.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 22.08.2024.
//

import SwiftUI

enum WeightUnit: String, CaseIterable {
    case kg = "kg"
    case lbs = "lbs"
}

struct WeightPickerModifier: ViewModifier {
    @Binding var weightOptions: [CUIDropdownItemModel]
    @Binding var isExpanded: Bool
    @Binding var selectedItem: CUIDropdownItemModel
    @Binding var selectedUnit: WeightUnit
    var buttonAction: (() -> Void)?
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isExpanded)
            
            if isExpanded {
                BackgroundBlurView(style: .dark)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isExpanded = false
                        }
                    }
            }
            
            if isExpanded {
                VStack {
                    Spacer()
                    WeightPickerView(
                        weightOptions: $weightOptions,
                        selectedUnit: $selectedUnit,
                        selectedItem: $selectedItem,
                        isExpanded: $isExpanded
                    )
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .transition(.move(edge: .bottom))
                    .offset(y: 30)
                }
                .ignoresSafeArea()
            }
        }
    }
}

extension View {
    func weightPickerModifier(
        weightOptions: Binding<[CUIDropdownItemModel]>,
        isExpanded: Binding<Bool>,
        selectedItem: Binding<CUIDropdownItemModel>,
        selectedUnit: Binding<WeightUnit>,
        buttonAction: (() -> Void)? = nil
    ) -> some View {
        modifier(WeightPickerModifier(
            weightOptions: weightOptions,
            isExpanded: isExpanded,
            selectedItem: selectedItem,
            selectedUnit: selectedUnit,
            buttonAction: buttonAction
        ))
    }
}
