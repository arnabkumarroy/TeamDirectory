//
//  TeamViewController.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController {
    
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var lblTeamDescription: UILabel!
    @IBOutlet weak var lblTeamStregth: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var selectedTeam:Team?
    var availableTeams:[Team]?
    
    let serviceManager = FireBaseServiceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLabels()
        self.title = "Team Details"
    }
    
    private func setLabels(){
        self.lblTeamName.text = selectedTeam?.teamName
        self.lblTeamDescription.text = selectedTeam?.teamDesc
        self.lblTeamStregth.text = String(describing: selectedTeam?.teamMembers.count ?? 0)
    }
}


extension TeamViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let teamDetaiViewController = TeamDetaiViewController.instantiate()
        teamDetaiViewController.flow = Flow(action: .addTeamMember, mode: .show)
        teamDetaiViewController.team = self.selectedTeam
        teamDetaiViewController.availableTeams = self.availableTeams
        teamDetaiViewController.teamMember = self.selectedTeam?.teamMembers[indexPath.row]
        self.navigationController?.pushViewController(teamDetaiViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let teamMember =  selectedTeam?.teamMembers[indexPath.row]
            UIViewController.showActivityIndicator()
            serviceManager.deleteTeamMember(teamID: selectedTeam?.teamID, teamMemberID: teamMember?.id) { status in
                UIViewController.hideActivityIndicator()
                if status {
                    self.selectedTeam?.teamMembers.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .left)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadDashboardNotification"), object: nil)
                } else {
                    self.showAlert(title: "Message", message: "Something went wrong,please try again later.")
                }
            }
        } else if editingStyle == .insert {
        }
    }
    
}

extension TeamViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTeam?.teamMembers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "TeamViewController")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TeamViewController")
        }
        cell.textLabel?.text = selectedTeam?.teamMembers[indexPath.row].fullName
        cell.detailTextLabel?.text = selectedTeam?.teamMembers[indexPath.row].tcsEmail
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "  selectedTeam members"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
}

