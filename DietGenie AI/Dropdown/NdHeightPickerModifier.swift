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

struct NdHeightPickerModifier: ViewModifier {
    @Binding var itemList: [CUIDropdownItemModel]
    @Binding var isExpanded: Bool
    @Binding var choosenItem: CUIDropdownItemModel
    var buttonAction: (() -> Void)?
    @Binding var selectedLengthUnit: LengthUnit // Use LengthUnit enum

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
                VStack(spacing: 0) {
                    Spacer()
                    CUIDropdown(
                        itemList: $itemList,
                        choosenItem: $choosenItem,
                        isExpanded: $isExpanded,
                        isSearchBarEnabled: false,
                        isLength: true,
                        searchText: "",
                        selectedLengthUnit: selectedLengthUnit,
                        selectedWeightUnit: WeightUnit.kg
                    )
                }
                .ignoresSafeArea()
                .transition(.move(edge: .bottom))
            }
        }
    }
}

extension View {
    func ndHeightPickerModifier(
        itemList: Binding<[CUIDropdownItemModel]>,
        isExpanded: Binding<Bool>,
        choosenItem: Binding<CUIDropdownItemModel>,
        isSearchBarEnabled: Bool = false,
        searchText: String = "",
        buttonAction: (() -> Void)? = nil,
        selectedUnit: Binding<LengthUnit> // Use LengthUnit enum
    ) -> some View {
        modifier(NdHeightPickerModifier(
            itemList: itemList,
            isExpanded: isExpanded,
            choosenItem: choosenItem,
            buttonAction: buttonAction,
            selectedLengthUnit: selectedUnit
        ))
    }
}
