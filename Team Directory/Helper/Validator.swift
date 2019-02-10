//
//  Validator.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import Foundation

class Validator {
    static func genericCheck(value:String) -> Bool {
        return !value.isEmpty
    }
    static func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    static func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "[0-9]{9,12}$"
        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
        return valid
    }
}

