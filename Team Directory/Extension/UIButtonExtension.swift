//
//  UIButtonExtension.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit

extension UIButton {
    func roundCorners() {
        self.layer.cornerRadius = self.layer.frame.height/2
        self.clipsToBounds = true
    }
}

