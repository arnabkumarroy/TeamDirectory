//
//  UITextFieldExtension.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit

extension UITextField {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 0, y: 0, width: 20, height: 20))
        iconView.image = image
        iconView.tintColor = UIColor.groupTableViewBackground
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 0, y: 0, width: 35, height: 30))
        iconView.center = iconContainerView.center
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    func setBorder() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.groupTableViewBackground.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}
