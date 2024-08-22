//
//  HeightPickerView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 22.08.2024.
//

import SwiftUI

struct HeightPickerView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var isPickerExpanded = false
    @State private var selectedHeight: CUIDropdownItemModel = CUIDropdownItemModel(text: "130 cm")
    @State private var heightOptions: [CUIDropdownItemModel] = []
    @State private var selectedUnit: LengthUnit = .cm
    
    var body: some View {
        VStack {
            // Header with buttons for unit selection
            HStack {
                Button(action: {
                    selectedUnit = .cm
                    updateHeightOptions(for: .cm)
                }) {
                    Text("cm")
                        .padding()
                        .background(selectedUnit == .cm ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    selectedUnit = .ft
                    updateHeightOptions(for: .ft)
                }) {
                    Text("ft")
                        .padding()
                        .background(selectedUnit == .ft ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            // Dropdown button to show the height picker
            CUIDropdownField(
                title: "Select Height",
                isExpanded: $isPickerExpanded,
                choosenItem: $selectedHeight
            )
            .padding()
        }
        .ndHeightPickerModifier(
            itemList: $heightOptions,
            isExpanded: $isPickerExpanded,
            choosenItem: $selectedHeight,
            isSearchBarEnabled: false,
            searchText: "",
            selectedUnit: $selectedUnit
        )
        .onAppear {
            // Initial population of height options
            updateHeightOptions(for: selectedUnit)
        }
        .background(VisualEffectBlur(blurStyle: .systemMaterialDark)) // Apply background blur effect
    }
    
    private func updateHeightOptions(for unit: LengthUnit) {
        let range: ClosedRange<Int>
        switch unit {
        case .cm:
            range = 130...250
        case .ft:
            range = 4...8 // Example range for feet
        }
        heightOptions = range.map { CUIDropdownItemModel(text: "\($0) \(unit.rawValue)") }
    }
}

struct HeightPickerView_Previews: PreviewProvider {
    static var previews: some View {
        HeightPickerView()
    }
}
