//
//  KeyboardListener.swift
//  NYTimesAPI
//
//  Created by Alex Hartwell on 9/15/17.
//  Copyright © 2017 ahartwel. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardListener {
    func setUpKeyboardListeners()
    func onKeyboardOpen(withFrame frame: CGRect)
    func onKeyboardClose()
}

extension KeyboardListener where Self: UIView {
    func setUpKeyboardListeners() {
        NotificationCenter.default.reactive.notification(name: .UIKeyboardWillShow).observeNext(with: { notification in
            guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
                return
            }
            self.onKeyboardOpen(withFrame: keyboardFrame)
        }).dispose(in: self.bag)
        
        NotificationCenter.default.reactive.notification(name: .UIKeyboardWillHide).observeNext(with: { _ in
            self.onKeyboardClose()
            self.setNeedsUpdateConstraints()
        }).dispose(in: self.bag)
    }
}
