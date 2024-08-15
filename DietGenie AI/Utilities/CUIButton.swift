//
//  CUIButton.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

struct CUIButton: View {
    @State var isAnimating = false
    let gradient = Gradient(colors: [.red, .blue])
    let text: String
    let action: () -> Void
    var body: some View {
        ZStack{
            
            LinearGradient(gradient: gradient,
                           startPoint: isAnimating ? .topTrailing : .bottomLeading,
                           endPoint: isAnimating ? .bottomTrailing : .center)
            .animation(.easeIn(duration: 1)
                .repeatForever(autoreverses: true), value: isAnimating)
            .frame(width: 280, height: 86, alignment: .center)
            
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .blur(radius: 8)
            
            Button {
                self.action()
            } label: {
                Text(text)
                    .font(.heading3)
                    .foregroundColor(Color.teal)
                    .frame(width: 280, height: 80, alignment: .center)
                    .background(Color.otherBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
           
        }
        .ignoresSafeArea()
        .onAppear {
            isAnimating.toggle()
        }
    }
}

#Preview {
    CUIButton(text: "Yo", action: {})
}
