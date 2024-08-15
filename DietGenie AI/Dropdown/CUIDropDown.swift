//
//  CUIDropDown.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

struct CUIDropdownItemModel: Codable, Hashable {
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
    @State var searchText: String
    var choosenItemColored: Bool = false
    
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
                Spacer(minLength: 0)
                Rectangle()
                    .frame(width: 50, height: 4)
                    .cornerRadius(15, corners: .allCorners)
                    .foregroundColor(.gray)
                    .offset(y: 10)
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
                    isExpanded: .constant(true), isSearchBarEnabled: true, searchText: "3")
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        .background(Color.black)
    }
}
