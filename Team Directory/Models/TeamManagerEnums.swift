//
//  TeamManagerEnums.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit

enum Action {
    case addTeam,addTeamMember
    var title:String {
        switch self {
        case .addTeam:
            return "Team"
        case .addTeamMember:
            return "Team member"
        }
    }
}

enum ActionMode {
    case new,edit,show
    
    var actionBtnTitle:String {
        switch self {
        case .edit,.new:
            return "Save"
        case .show:
            return "Edit"
        }
    }
}

enum RowType : String {
    case fullName,birthday,citiEmail,tcsEmail,assetId,teamName,doj,empId,experience,geId,phone,soeId,teamDesc
    
    var placeHolder:String {
        switch self {
        case .fullName:
            return "Enter full name"
        case .birthday:
            return "Enter birthday #dd-MM-yyyy"
        case .citiEmail:
            return "Enter email #@citi.com"
        case .tcsEmail:
            return "Enter email #@tcs.com"
        case .assetId:
            return "Enter asset ID"
        case .teamName:
            return "Select team"
        case .doj:
            return "Enter DOB #dd-MM-yyyy"
        case .empId:
            return "Enter employee ID"
        case .experience:
            return "Enter experience"
        case .geId:
            return "Enter GEID"
        case .phone:
            return "Enter phone number"
        case .soeId:
            return "Enter SOEID"
        case .teamDesc:
            return "Enter description"
        }
    }
    
    var title:String {
        switch self {
        case .fullName:
            return "Name"
        case .birthday:
            return "Birthday"
        case .citiEmail:
            return "Citi email"
        case .tcsEmail:
            return "Tcs email"
        case .assetId:
            return "Asset ID"
        case .teamName:
            return "Team"
        case .doj:
            return "Date of Joining"
        case .empId:
            return "Employee ID"
        case .experience:
            return "Experience"
        case .geId:
            return "GEID"
        case .phone:
            return "Phone number"
        case .soeId:
            return "SOEID"
        case .teamDesc:
            return "Team description"
        }
    }
    
    var keyBoadType:UIKeyboardType {
        switch self {
        case .fullName,.assetId,.teamDesc,.soeId:
            return .asciiCapable
        case .citiEmail,.tcsEmail:
            return .emailAddress
        case .empId,.geId:
            return .numberPad
        case .phone:
            return .phonePad
        case .experience:
            return .decimalPad
        default:
            return .default
        }
    }
    
    func validate(value:String, checkForEmptyValue:Bool = false) -> Bool {
        
        if checkForEmptyValue {
            guard Validator.genericCheck(value: value) else {
                return false
            }
        }
        
        switch self {
        case .tcsEmail,.citiEmail:
            return Validator.isValidEmail(email: value)
        case .phone:
            return Validator.isValidPhone(phone: value)
        default:
            return true
        }
    }
}

enum AlertAction{
    case Ok
    case Cancel
}

