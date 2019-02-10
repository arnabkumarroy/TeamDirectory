//
//  FireBaseServiceManager.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import Firebase

class FireBaseServiceManager {
    
    var ref: DatabaseReference?
    
    init() {
        ref = Database.database().reference()
    }
    
    func readTeams(completion : @escaping ([Team]?) -> ()) {
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            print("data access success")
            guard let dataSnapsotValue = snapshot.value as? NSDictionary else { return }
            let model = self.convertDictionaryArrayToModelArray(inputDict: dataSnapsotValue)
            completion(model)
        }) { (error) in
            completion([Team]())
            print("data access failed")
            print(error.localizedDescription)
        }
    }
    
    
    func addTeamMember(teamMember:[String:Any], teamID:String?, completion : @escaping (Bool) -> ()) {
        
        guard let teamID = teamID, !teamID.isEmpty else {
            completion(false)
            return
        }
        
        let newMemberref = ref?.child("teamMembers").child(teamID).childByAutoId()
        
        guard let key = newMemberref?.key else {
            completion(false)
            return
        }
        
        var teamMemberWithID = teamMember
        teamMemberWithID["id"] = key
        
        newMemberref?.setValue(teamMemberWithID, withCompletionBlock: { (error, ref) in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    func updateTeamMember(teamMember:[String:Any], teamID:String?,teamMemberID:String?, completion : @escaping (Bool) -> ()) {
        
        guard let teamID = teamID, !teamID.isEmpty,let teamMemberID = teamMemberID, !teamMemberID.isEmpty else {
            completion(false)
            return
        }
        
        let newMemberref = ref?.child("teamMembers").child(teamID).child(teamMemberID)
        
        newMemberref?.updateChildValues(teamMember, withCompletionBlock: { (error, ref) in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    
    func addTeam(teamDict:[String:Any],completion : @escaping (Bool) -> ()) {
        let newMemberref = ref?.child("team").childByAutoId()
        
        guard let key = newMemberref?.key else {
            completion(false)
            return
        }
        
        var teamDictWithAutoID = teamDict
        teamDictWithAutoID["id"] = key
        
        newMemberref?.setValue(teamDictWithAutoID, withCompletionBlock: { (error, ref) in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    func deleteTeamMember(teamID:String?,teamMemberID:String?, completion : @escaping (Bool) -> ()) {
        guard let teamID = teamID, !teamID.isEmpty,let teamMemberID = teamMemberID, !teamMemberID.isEmpty else {
            completion(false)
            return
        }
        
        let newMemberref = ref?.child("teamMembers").child(teamID).child(teamMemberID)
        
        newMemberref?.removeValue(completionBlock: { (error, ref) in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    private func convertDictionaryArrayToModelArray(inputDict:NSDictionary) -> [Team] {
        
        guard let teamsDict = inputDict["team"] as? NSDictionary else {
            return [Team]()
        }
        
        var mappedTeamModelArray = [Team]()
        teamsDict.allValues.forEach { object in
            guard let modelDict = object as? [String:Any], let team = Team(with: modelDict) else { return }
            mappedTeamModelArray.append(team)
        }
        
        guard let teamsMembersDict = inputDict["teamMembers"] as? NSDictionary else {
            return mappedTeamModelArray
        }
        
        let mappedTeamAndMemberModelArray:[Team] = mappedTeamModelArray.map { team -> Team in
            if let membersDict = teamsMembersDict.value(forKey: team.teamID) as? NSDictionary {
                var newTeam = team
                var teamMembers = [TeamMember]()
                membersDict.allValues.forEach({ object in
                    guard let modelDict = object as? [String:Any], let member = TeamMember(with: modelDict) else { return }
                    teamMembers.append(member)
                })
                newTeam.teamMembers = teamMembers
                return newTeam
            } else {
                return team
            }
        }
        
        return mappedTeamAndMemberModelArray
    }
    
}
