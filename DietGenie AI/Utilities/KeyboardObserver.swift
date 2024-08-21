//
//  KeyboardObserver.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 20.08.2024.
//

import SwiftUI

class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible = false
    @Published var keyboardHeight: CGFloat = 0

    private var keyboardWillChangeFrameObserver: NSObjectProtocol?

    init() {
        observeKeyboardNotifications()
    }

    deinit {
        stopObserving()
    }

    private func observeKeyboardNotifications() {
        keyboardWillChangeFrameObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.keyboardWillChangeFrame(notification)
        }
    }

    private func stopObserving() {
        if let keyboardWillChangeFrameObserver = keyboardWillChangeFrameObserver {
            NotificationCenter.default.removeObserver(keyboardWillChangeFrameObserver)
        }
    }

    private func keyboardWillChangeFrame(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let window = UIApplication.shared.windows.first {
            let keyboardFrameInView = window.convert(keyboardFrame, to: nil)
            let isKeyboardVisible = keyboardFrameInView.minY < window.bounds.height
            let keyboardHeight = isKeyboardVisible ? keyboardFrameInView.height : 0

            DispatchQueue.main.async {
                self.isKeyboardVisible = isKeyboardVisible
                self.keyboardHeight = keyboardHeight
            }
        }
    }
}
