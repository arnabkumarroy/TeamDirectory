//
//  TeamDetaiViewController.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit

class TeamDetaiViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    private var dataSource = [TeamSection]()
    private var dataSourceOriginal = [TeamSection]()
    private var navigationBtn:UIBarButtonItem?
    private let dataBaseManger = FireBaseServiceManager()
    
    var flow:Flow = Flow(action: .addTeamMember, mode: .new)
    var team:Team?
    var teamMember:TeamMember?
    var availableTeams:[Team]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createDataModel()
        self.enableTapEndEditing()
        self.setUpNavigationBarItems()
        self.title = "Details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.checkAndEnableRightBarButton()
        addKeyboardFrameChangesObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardFrameChangesObserver()
    }
    
    private func createDataModel() {
        dataSource.removeAll()
        if flow.action == .addTeam {
            let teamName = TeamRow(type: .teamName, displayValue: "")
            let teamDescription = TeamRow(type: .teamDesc, displayValue: "")
            let teamSection = TeamSection(sectionTitle: "Team Details", rows: [teamName,teamDescription])
            dataSource.append(teamSection)
        } else if flow.action == .addTeamMember {
            let teamRow = TeamRow(type: .teamName, displayValue: teamMember?.teamName ?? "", options:["Teams":self.availableTeams] )
            let sectionTeam = TeamSection(sectionTitle: "Team Details", rows: [teamRow])
            dataSource.append(sectionTeam)
            
            let rowFirstName = TeamRow(type: .fullName, displayValue: teamMember?.fullName ?? "")
            let rowBirthday = TeamRow(type: .birthday, displayValue: teamMember?.birthday ?? "")
            let section1 = TeamSection(sectionTitle: "Personal Details", rows: [rowFirstName,rowBirthday])
            dataSource.append(section1)
            
            let rowCitiEmail = TeamRow(type: .citiEmail, displayValue: teamMember?.citiEmail ?? "")
            let rowTcsEmail = TeamRow(type: .tcsEmail, displayValue: teamMember?.tcsEmail ?? "")
            let rowPhone = TeamRow(type: .phone, displayValue: teamMember?.phone ?? "")
            
            let section2 = TeamSection(sectionTitle: "Contact Details", rows: [rowCitiEmail,rowTcsEmail,rowPhone])
            dataSource.append(section2)
            
            let doj = TeamRow(type: .doj, displayValue: teamMember?.doj ?? "")
            let experience = TeamRow(type: .experience, displayValue: String(describing: teamMember?.experience ?? 0.0))
            let assetId = TeamRow(type: .assetId, displayValue: teamMember?.assetId ?? "")
            let empId = TeamRow(type: .empId, displayValue: teamMember?.empId ?? "")
            let soeId = TeamRow(type: .soeId, displayValue: teamMember?.soeId ?? "")
            let geId = TeamRow(type: .geId, displayValue: teamMember?.geId ?? "")
            
            let section3 = TeamSection(sectionTitle: "Official Details", rows: [doj,experience,assetId,empId,soeId,geId])
            dataSource.append(section3)
        } else {
            print("Unhandled case")
        }
        self.tblView.reloadData()
    }
    
    private func validateData() -> Bool {
        for section in dataSource {
            for row in section.rows {
                if !row.type.validate(value: row.displayValue,checkForEmptyValue: true) {
                    return false
                }
            }
        }
        return true
    }
    
    private func setUpNavigationBarItems() {
        navigationBtn = UIBarButtonItem(title: self.flow.mode.actionBtnTitle, style: .plain, target: self, action: #selector(handleNavigationBarButtonAction))
        self.navigationItem.rightBarButtonItem = navigationBtn
    }
    
    @objc func handleNavigationBarButtonAction() {
        self.view.endEditing(true)
        if self.flow.mode == .show  {
            self.showMessegeBanner(withTitle: "Info", message: "Editing mode enabled")
            self.flow.mode = .edit
            navigationBtn?.title = self.flow.mode.actionBtnTitle
            self.tblView.reloadData()
            return
        }
        
        switch (self.flow.action,self.flow.mode) {
        case (.addTeam,.new):
            //Firebase call to add new team
            let teamDict = self.formTeamMemberDictionary()
            dataBaseManger.addTeam(teamDict: teamDict) { status in
                DispatchQueue.main.async { [weak self] in
                    let message = status == true ? "Successfully added" : "Something went wrong,please try again later "
                    self?.showAlert(title: "Message", message: message, handler: { _ in
                        self?.dismiss(animated: true, completion: {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadDashboardNotification"), object: nil)
                        })
                    })
                }
            }
        case (.addTeamMember,.edit):
            //Firebase call to edit member existing team
            let teamMemberDict = self.formTeamMemberDictionary()
            dataBaseManger.updateTeamMember(teamMember: teamMemberDict, teamID: team?.teamID, teamMemberID: teamMember?.id) { status in
                DispatchQueue.main.async { [weak self] in
                    let message = status == true ? "Successfully updated" : "Something went wrong,please try again later "
                    self?.showAlert(title: "Message", message: message, handler: { _ in
                        self?.navigationController?.popToRootViewController(animated: true)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadDashboardNotification"), object: nil)
                    })
                }
            }
        case (.addTeamMember,.new):
            //Firebase call to add memeber new team
            let teamMember = self.formTeamMemberDictionary()
            dataBaseManger.addTeamMember(teamMember: teamMember, teamID: team?.teamID) { status in
                DispatchQueue.main.async { [weak self] in
                    let message = status == true ? "Successfully added" : "Something went wrong,please try again later "
                    self?.showAlert(title: "Message", message: message, handler: { _ in
                        self?.dismiss(animated: true, completion: {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadDashboardNotification"), object: nil)
                        })
                    })
                }
            }
        default:
            print("Unhandled Cases")
        }
    }
    
    private func formTeamMemberDictionary() -> [String:Any] {
        var rows = [TeamRow]()
        for section in dataSource {
            rows.append(contentsOf: section.rows)
        }
        
        var dict = [String:Any]()
        for row in rows {
            dict[row.type.rawValue] = row.displayValue
        }
        
        dict[RowType.experience.rawValue] = Float(dict[RowType.experience.rawValue] as? String ?? "")
        
        return dict
    }
    
    private func showNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func checkAndEnableRightBarButton(){
        navigationBtn?.isEnabled = self.validateData()
    }
    
    deinit {
        removeKeyboardFrameChangesObserver()
    }
}

extension TeamDetaiViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension TeamDetaiViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].rows.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamDetailsTextInputCell.identifier) as? TeamDetailsTextInputCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        let model = dataSource[indexPath.section].rows[indexPath.row]
        cell.setUp(model: model, indexPath: indexPath, flow: self.flow)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?  {
        return dataSource[section].sectionTitle
    }
}

extension TeamDetaiViewController: TeamDetailsTextInputCellDelegate {
    func setNewTeam(team: Team) {
        self.team = team
    }
    
    func valueChanged(forIndexPath index: IndexPath, newValue: String) {
        dataSource[index.section].rows[index.row].displayValue = newValue
        self.checkAndEnableRightBarButton()
    }
    
    func invalidInput(type:RowType?) {
        self.checkAndEnableRightBarButton()
        if !self.isBeingDismissed {
            self.showErrorBanner(withTitle: "Error", message: "Please check the input")
        }
    }
}

extension TeamDetaiViewController: LoadableViewController {
    static var storyboardFileName: String {
        return "Main"
    }
}

extension TeamDetaiViewController: ModifableInsetsOnKeyboardFrameChanges {
    var scrollViewToModify: UIScrollView { return tblView }
}

