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

struct NdWeightPickerModifier: ViewModifier {
    @Binding var itemList: [CUIDropdownItemModel]
    @Binding var isExpanded: Bool
    @Binding var choosenItem: CUIDropdownItemModel
    var buttonAction: (() -> Void)?
    @Binding var selectedWeightUnit: WeightUnit

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
                        isLength: false,
                        searchText: "",
                        selectedLengthUnit: LengthUnit.cm,
                        selectedWeightUnit: selectedWeightUnit
                    )
                }
                .ignoresSafeArea()
                .transition(.move(edge: .bottom))
            }
        }
    }
}

extension View {
    func ndWeightPickerModifier(
        itemList: Binding<[CUIDropdownItemModel]>,
        isExpanded: Binding<Bool>,
        choosenItem: Binding<CUIDropdownItemModel>,
        isSearchBarEnabled: Bool = false,
        searchText: String = "",
        buttonAction: (() -> Void)? = nil,
        selectedWeightUnit: Binding<WeightUnit>
    ) -> some View {
        modifier(NdWeightPickerModifier(
            itemList: itemList,
            isExpanded: isExpanded,
            choosenItem: choosenItem,
            buttonAction: buttonAction,
            selectedWeightUnit: selectedWeightUnit
        ))
    }
}
