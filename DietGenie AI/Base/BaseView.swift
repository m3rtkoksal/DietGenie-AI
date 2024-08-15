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
}

struct BaseView<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var currentViewModel: BaseViewModel
    @State var isSuccess = true
    var background: BaseViewBackgroundType
    var hideBackButton: Bool
    let content: Content
    @Binding var showIndicator: Bool
    
    init(
         currentViewModel: BaseViewModel,
         background: BaseViewBackgroundType? = nil,
         hideBackButton: Bool? = false,
         showIndicator: Binding<Bool>,
         @ViewBuilder content: () -> Content)
    {
        self.currentViewModel = currentViewModel
        self.background = background ?? .solidWhite
        self.hideBackButton = hideBackButton ?? false
        self.content = content()
        self._showIndicator = showIndicator
    }
    
    var body: some View {
        ZStack {
            Color.darkPurple
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



