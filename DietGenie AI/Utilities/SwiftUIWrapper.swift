//
//  SwiftUIWrapper.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 17.08.2024.
//

import SwiftUI

struct SwiftUIWrapper<T: View>: UIViewControllerRepresentable {
    let content: () -> T
    func makeUIViewController(context: Context) -> UIHostingController<T> {
        UIHostingController(rootView: content())
    }
    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {}
}
