//
//  TeamManagerStructs.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

struct Team {
    var teamDesc: String
    var teamName: String
    var teamID: String
    var teamMembers:[TeamMember]
    
    init?(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary else { return nil  }
        
        guard let teamName = dictionary["teamName"] as? String else {
            return nil
        }
        self.teamDesc = dictionary["teamDesc"] as? String ?? ""
        self.teamName = teamName
        self.teamID = dictionary["id"] as? String ?? ""
        self.teamMembers = dictionary["teamMembers"] as? [TeamMember] ?? [TeamMember]()
    }
}

struct TeamMember {
    var assetId:String
    var birthday:String
    var citiEmail:String
    var doj:String
    var empId:String
    var experience:Float
    var fullName:String
    var id:String
    var geId:String
    var phone:String
    var soeId:String
    var tcsEmail:String
    var teamName:String
    
    init?(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary else { return nil  }
        
        self.assetId = dictionary["assetId"] as? String ?? ""
        self.birthday = dictionary["birthday"] as? String ?? ""
        self.citiEmail = dictionary["citiEmail"] as? String ?? ""
        self.doj = dictionary["doj"] as? String ?? ""
        self.empId = dictionary["empId"] as? String ?? ""
        self.experience = dictionary["experience"] as? Float ?? 0.0
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
        self.geId = dictionary["geId"] as? String ?? ""
        self.phone = dictionary["phone"] as? String ?? ""
        self.soeId = dictionary["soeId"] as? String ?? ""
        self.tcsEmail = dictionary["tcsEmail"] as? String ?? ""
        self.teamName = dictionary["teamName"] as? String ?? ""
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "assetId" : assetId,
            "birthday" : birthday,
            "citiEmail" : citiEmail,
            "doj" : doj,
            "empId" : empId,
            "experience" : experience,
            "fullName" : fullName,
            "id" : id,
            "geId" : geId,
            "phone" : phone,
            "soeId" : soeId,
            "tcsEmail" : tcsEmail,
            "teamName" : teamName,
        ]
    }
}

struct Flow {
    let action:Action
    var mode:ActionMode
}


struct TeamSection {
    let sectionTitle:String
    var rows:[TeamRow]
}
struct TeamRow {
    let type:RowType
    var displayValue:String
    let options:[String:Any]?
    
    init(type:RowType,displayValue:String,options:[String:Any]? = nil) {
        self.type = type
        self.displayValue = displayValue
        self.options = options
    }
}

