//
//  UserSettings.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import Foundation

class UserSettings {
    
    private static let rememberMe = "remeberme"
    
    static func storeUserId(Id value:String) {
        UserDefaults.standard.set(value, forKey: UserSettings.rememberMe)
    }
    
    static func getUserID()-> String? {
        return UserDefaults.standard.object(forKey: UserSettings.rememberMe) as? String
    }
    
    static func clearUserID() {
        UserDefaults.standard.removeObject(forKey: UserSettings.rememberMe)
    }
}

