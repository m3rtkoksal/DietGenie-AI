//
//  BaseView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

enum BaseViewBackgroundType{
    case black
    case solidWhite
    case transparent
    case lightTeal
}

struct BaseView<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var currentViewModel: BaseViewModel
    @State var isSuccess = true
    var background: BaseViewBackgroundType
    var hideBackButton: Bool
    let content: Content
    @Binding var showIndicator: Bool
    var scrollViewOffset: CGFloat?
    
    init(
         currentViewModel: BaseViewModel,
         background: BaseViewBackgroundType? = nil,
         hideBackButton: Bool? = false,
         showIndicator: Binding<Bool>,
         scrollViewOffset: CGFloat? = nil,
         @ViewBuilder content: () -> Content)
    {
        self.currentViewModel = currentViewModel
        self.background = background ?? .solidWhite
        self.hideBackButton = hideBackButton ?? false
        self.content = content()
        self.scrollViewOffset = scrollViewOffset
        self._showIndicator = showIndicator
    }
    
    var cRadius: CGFloat {
        if let scrollViewOffset = scrollViewOffset {
            if scrollViewOffset > 31 {
                return 0
            }
            else if scrollViewOffset >= 0 {
                return 31 - scrollViewOffset
            } else {
                return 31
            }
        } else {
            return 31
        }
    }
    
    var body: some View {
        ZStack {
            Color.purple
                .ignoresSafeArea()
            switch background {
            case .solidWhite:
                    Color.solidWhite
                        .ignoresSafeArea()
            case .black:
                Color.otherBlack
                    .ignoresSafeArea()
            case .transparent:
                Color.clear
                    .ignoresSafeArea()
            case .lightTeal:
                Color.lightTeal
                    .ignoresSafeArea()
            }
            
            // CONTENT
    
            content
            
            if showIndicator {
               CUILoadingView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}



