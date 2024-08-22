//
//  CUIDropDown.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

struct CUIDropdownItemModel: Codable, Hashable, Identifiable {
    var id : String?
    var icon: String? = ""
    let text: String
    var code: String?
    var hasArrow: Bool?
}

struct CUIDropdown: View {
    @Binding var itemList: [CUIDropdownItemModel]
    @State private var totalHeight :CGFloat = 0
    @Binding var choosenItem: CUIDropdownItemModel
    @Binding var isExpanded: Bool
    var isSearchBarEnabled: Bool
    var isLength: Bool
    @State var searchText: String
    var choosenItemColored: Bool = false
    @State var selectedLengthUnit: LengthUnit
    @State var selectedWeightUnit: WeightUnit
    var lengthUnits: [LengthUnit] = [.cm, .ft]
    var weightUnits: [WeightUnit] = [.kg, .lbs]
    
    private var filteredItems: [CUIDropdownItemModel] {
        if searchText.isEmpty {
            return itemList
        } else {
            return itemList.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        VStack {
            Spacer()
            VStack {
                HStack {
                    ForEach(lengthUnits, id: \.self) { unit in
                        Button(action: {
                            selectedLengthUnit = unit
                            itemList = loadLengthItems(for: unit)
                        }) {
                            Text(unit.rawValue)
                                .frame(width: 34)
                                .padding()
                                .background(selectedLengthUnit == unit ? Color.topGreen : Color.white)
                                .foregroundColor(selectedLengthUnit == unit ? Color.black : Color.progressBarPassive)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(selectedLengthUnit == unit ? Color.black : Color.progressBarPassive, lineWidth: 1) // Black border with 2 points width
                                )
                        }
                    }
                    .onAppear {
                        if isLength {
                            itemList = loadLengthItems(for: selectedLengthUnit)
                        } else {
                            itemList = loadWeightItems(for: selectedWeightUnit)
                        }
                    }
                }
                .offset(y: 10)
                .hiddenConditionally(isHidden: !isLength)
               
                HStack {
                    ForEach(weightUnits, id: \.self) { unit in
                        Button(action: {
                            selectedWeightUnit = unit
                            itemList = loadWeightItems(for: unit)
                        }) {
                            Text(unit.rawValue)
                                .frame(width: 34)
                                .padding()
                                .background(selectedWeightUnit == unit ? Color.topGreen : Color.white)
                                .foregroundColor(selectedWeightUnit == unit ? Color.black : Color.progressBarPassive)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(selectedWeightUnit == unit ? Color.black : Color.progressBarPassive, lineWidth: 1) // Black border with 2 points width
                                )
                        }
                    }
                    .onAppear {
                        if isLength {
                            itemList = loadLengthItems(for: selectedLengthUnit)
                        } else {
                            itemList = loadWeightItems(for: selectedWeightUnit)
                        }
                    }
                }
                .offset(y: 10)
                .hiddenConditionally(isHidden: isLength)
                
                Spacer(minLength: 0)
                Rectangle()
                    .frame(width: 50, height: 4)
                    .cornerRadius(15, corners: .allCorners)
                    .foregroundColor(.gray)
                    .offset(y: 10)
                    .hiddenConditionally(isHidden: !lengthUnits.isEmpty || !weightUnits.isEmpty)
                CUISearchBar(text: $searchText)
                    .padding(.top)
                    .padding(.horizontal)
                    .hiddenConditionally(isHidden: !isSearchBarEnabled)
                ScrollView(showsIndicators: false) {
                    ForEach(filteredItems, id: \.self) { item in
                        Button {
                            withAnimation {
                                choosenItem = item
                                isExpanded = false
                            }
                        } label: {
                            CUIDropdownElement(item: item, choosenItem: choosenItemColored ? choosenItem == item : false)
                        }
                        if itemList.last != item {
                            Divider()
                        }
                    }
                    .padding(.vertical, 30)
                }
                .frame(maxHeight: UIScreen.screenHeight * 0.6)
                .onPreferenceChange(ItemHeightPreferenceKey.self) { heights in
                    let topHeight: CGFloat = 57
                    let spacingHeight = CGFloat(itemList.count) * 48 // Calculate total spacing height
                    let bottomHeight: CGFloat = 18
                    totalHeight = heights.reduce(0, +) + spacingHeight + topHeight + bottomHeight
                }
            }
            .frame(maxHeight: UIScreen.screenHeight * 0.6)
            .background(Color.solidWhite)
            .cornerRadius(32, corners: [.topLeft, .topRight])
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color.white)
                    .padding(.bottom, -40)
            )
            .padding(.top, itemList.count > 20 ? nil : UIScreen.main.bounds.height - totalHeight-40)
        }
        .zIndex(1)
    }
    
    private func loadLengthItems(for unit: LengthUnit) -> [CUIDropdownItemModel] {
            let range: ClosedRange<Int>
            switch unit {
            case .cm:
                range = 130...250
            case .ft:
                let step = 0.1
                let range = stride(from: 4.0, to: 8.1, by: step) // From 4.0 to 8.0 in 0.1 increments
                return range.map { CUIDropdownItemModel(text: String(format: "%.1f \(unit.rawValue)", $0)) }
            }
            return range.map { CUIDropdownItemModel(text: "\($0) \(unit.rawValue)") }
        }
    
    private func loadWeightItems(for unit: WeightUnit) -> [CUIDropdownItemModel] {
        let range: ClosedRange<Int>
        switch unit {
        case .kg:
            range = 30...250
            return range.map { CUIDropdownItemModel(text: "\($0) \(unit.rawValue)") }
        case .lbs:
            let floatRange = stride(from: 60.0, to: 551.0, by: 1.0)
            return floatRange.map { CUIDropdownItemModel(text: String(format: "%.1f \(unit.rawValue)", $0)) }
        }
    }
}

struct CUIDropdown_Previews: PreviewProvider {
    static var previews: some View {
        CUIDropdown(itemList: .constant([
            CUIDropdownItemModel(icon: "", text: "Lorem Ipsum"),
            CUIDropdownItemModel(icon: "", text: "Lorem Ipsum2"),
            CUIDropdownItemModel(icon: "", text: "Lorem Ipsum3"),
            CUIDropdownItemModel(icon: "", text: "Lorem Ipsum4"),
            CUIDropdownItemModel(icon: "", text: "Lorem Ipsum5"),
            CUIDropdownItemModel(icon: "", text: "Lorem Ipsum6"),
            CUIDropdownItemModel(icon: "", text: "Lorem Ipsum3"),
            CUIDropdownItemModel(icon: "", text: "🇹🇷 +90 Türkiye"),
            CUIDropdownItemModel(text: "Lorem Ipsum5")]),
                    choosenItem: .constant(CUIDropdownItemModel(icon: "", text: "Lorem Ipsum Org")),
                    isExpanded: .constant(true), isSearchBarEnabled: true, isLength: true, searchText: "3", selectedLengthUnit: LengthUnit.cm, selectedWeightUnit: WeightUnit.kg)
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        .background(Color.black)
    }
}
