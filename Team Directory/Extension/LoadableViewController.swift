//
//  LoadableViewController.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import Foundation
import UIKit

protocol LoadableViewController: class {
    static var storyboardFileName: String { get }
    static var storyboardID: String { get }
}

extension LoadableViewController {
    static var storyboardID: String {
        return String(describing: self)
    }
}

extension LoadableViewController where Self: UIViewController {
    static func instantiate() -> Self {
        let storyboard = Self.storyboardFileName
        guard let vc = UIStoryboard.instanceofViewController(with: storyboardID, from: storyboardFileName) as? Self else {
            fatalError("The viewController '\(self.storyboardID)' of '\(storyboard)' is not of class '\(self)'")
        }
        
        return vc
    }
}

extension UIStoryboard {
    class func instanceofViewController(with storyboardID: String, from storyboardFileName: String) -> UIViewController? {
        let storyboard = UIStoryboard(
            name: storyboardFileName,
            bundle: nil
        )
        
        return storyboard.instantiateViewController(withIdentifier: storyboardID)
    }
}

