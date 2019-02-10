//
//  KeyboardChangeFrameObserver.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit

public protocol KeyboardChangeFrameObserver: class {
    func willChangeKeyboardFrame(height: CGFloat, animationDuration: TimeInterval, animationOptions: UIView.AnimationOptions)
}

public extension KeyboardChangeFrameObserver {
    func addKeyboardFrameChangesObserver() {
        let center = NotificationCenter.default
        
        center.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { [weak self] (notification) in
            self?.sendDelegate(notification: notification, willHide: false)
        }
        
        center.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] (notification) in
            self?.sendDelegate(notification: notification, willHide: true)
        }
    }
    
    func removeKeyboardFrameChangesObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func sendDelegate(notification: Notification, willHide: Bool) {
        guard let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let rawAnimationCurveNumber = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else { return }
        
        let rawAnimationCurve = rawAnimationCurveNumber.uint32Value << 16
        let animationCurve = UIView.AnimationOptions(rawValue: UInt(rawAnimationCurve))
        
        let keyboardHeight = willHide ? 0 : keyboardEndFrame.height
        
        willChangeKeyboardFrame(height: keyboardHeight,
                                animationDuration: animationDuration,
                                animationOptions: [.beginFromCurrentState, animationCurve])
    }
}

