//
//  ModifableInsetsOnKeyboardFrameChanges.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit

/// Insets of a scroll view will be changed when keyboard will appear
protocol ModifableInsetsOnKeyboardFrameChanges: KeyboardChangeFrameObserver {
    /// Insets of that scroll view will be modified on keyboard appearance
    var scrollViewToModify: UIScrollView { get }
}

/// Default implementation for `UIViewController`
extension ModifableInsetsOnKeyboardFrameChanges where Self: UIViewController {
    func willChangeKeyboardFrame(height: CGFloat, animationDuration: TimeInterval, animationOptions: UIView.AnimationOptions) {
        var adjustedHeight = height
        
        if let tabBarHeight = self.tabBarController?.tabBar.frame.height {
            adjustedHeight -= tabBarHeight
        } else if let toolbarHeight = navigationController?.toolbar.frame.height, navigationController?.isToolbarHidden == false {
            adjustedHeight -= toolbarHeight
        }
        
        if adjustedHeight < 0 { adjustedHeight = 0 }
        
        UIView.animate(withDuration: animationDuration, animations: {
            let newInsets = UIEdgeInsets(top: 0, left: 0, bottom: adjustedHeight, right: 0)
            self.scrollViewToModify.contentInset = newInsets
            self.scrollViewToModify.scrollIndicatorInsets = newInsets
        })
    }
}

