//
//  NdHeightPickerModifier.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 22.08.2024.
//

import SwiftUI

enum LengthUnit: String, CaseIterable {
    case cm = "cm"
    case ft = "ft"
}

struct HeightPickerModifier: ViewModifier {
    @Binding var lengthOptions: [CUIDropdownItemModel]
    @Binding var isExpanded: Bool
    @Binding var selectedItem: CUIDropdownItemModel
    @Binding var selectedUnit: LengthUnit
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
                    HeightPickerView(
                        lengthOptions: $lengthOptions,
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
    func heightPickerModifier(
        lengthOptions: Binding<[CUIDropdownItemModel]>,
        isExpanded: Binding<Bool>,
        selectedItem: Binding<CUIDropdownItemModel>,
        selectedUnit: Binding<LengthUnit>,
        buttonAction: (() -> Void)? = nil
    ) -> some View {
        modifier(HeightPickerModifier(
            lengthOptions: lengthOptions,
            isExpanded: isExpanded,
            selectedItem: selectedItem,
            selectedUnit: selectedUnit,
            buttonAction: buttonAction
        ))
    }
}
