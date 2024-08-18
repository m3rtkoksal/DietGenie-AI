//
//  NavigationUtil.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 18.08.2024.
//

import SwiftUI

import SwiftUI

struct NavigationUtil {
    static func popToRootView() {
        guard let window = UIApplication.shared.windows.first else { return }
        if let rootViewController = window.rootViewController as? UINavigationController {
            rootViewController.popToRootViewController(animated: true)
        }
    }
}
