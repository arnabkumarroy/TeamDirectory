//
//  TeamDetailsTextInputCellDelegate.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit
protocol TeamDetailsTextInputCellDelegate :class {
    func valueChanged(forIndexPath index:IndexPath, newValue:String)
    func invalidInput(type:RowType?)
    func setNewTeam(team:Team)
}
class TeamDetailsTextInputCell: UITableViewCell {
    
    static let identifier = "TeamDetailsTextInputCell"
    weak var delegate:TeamDetailsTextInputCellDelegate?
    private var indexPath = IndexPath(row: 0, section: 0)
    var model:TeamRow!
    
    var teamPickerView:UIPickerView!
    var teams:[Team] {
        guard let teams = self.model.options?["Teams"] as? [Team] else { return [Team]() }
        return teams
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtFieldInput: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.txtFieldInput.delegate = self
    }
    
    func setUp(model:TeamRow, indexPath:IndexPath, flow:Flow) {
        self.model = model
        self.indexPath = indexPath
        self.lblTitle.text = model.type.title
        self.txtFieldInput.text = model.displayValue
        self.txtFieldInput.placeholder = model.type.placeHolder
        self.txtFieldInput.keyboardType = model.type.keyBoadType
        self.txtFieldInput.isEnabled = flow.mode != .show
        
        if model.type == .teamName {
            switch (flow.action,flow.mode) {
            case (.addTeamMember,.new):
                self.addPickerView()
            case (.addTeamMember,_):
                self.txtFieldInput.isEnabled = false
            case (.addTeam,_):
                self.txtFieldInput.isEnabled = true
            }
        } else {
            txtFieldInput.inputView = nil
        }
    }
}

extension TeamDetailsTextInputCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if (self.model.type.validate(value: self.txtFieldInput.text ?? "")) {
            delegate?.valueChanged(forIndexPath: self.indexPath, newValue: self.txtFieldInput.text ?? "")
        } else {
            delegate?.invalidInput(type: self.model?.type)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Format Date  dd-MM-yyyy
        if [RowType.birthday,.doj].contains(self.model.type) {
            if (textField.text?.count == 2) || (textField.text?.count == 5) {
                if !(string == "") {
                    textField.text = (textField.text)! + "-"
                }
            }
            return !(textField.text!.count > 9 && (string.count ) > range.length)
        }
        else {
            return true
        }
    }
}

extension TeamDetailsTextInputCell : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func addPickerView() {
        self.teamPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: 160))
        txtFieldInput.inputView = teamPickerView
        
        
        self.teamPickerView.delegate = self
        self.teamPickerView.dataSource = self
        self.teamPickerView.backgroundColor = UIColor.groupTableViewBackground
        
        let toolBarForPicker = UIToolbar()
        toolBarForPicker.barStyle = .black
        toolBarForPicker.backgroundColor = UIColor.lightGray
        toolBarForPicker.isTranslucent = true
        toolBarForPicker.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(TeamDetailsTextInputCell.doneClick))
        doneButton.tintColor = UIColor.gray
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBarForPicker.setItems([spaceButton, doneButton], animated: false)
        toolBarForPicker.isUserInteractionEnabled = true
        txtFieldInput.inputAccessoryView = toolBarForPicker
        
        var selectedIndex = 0
        for (index,team) in self.teams.enumerated() {
            if team.teamName.lowercased() == self.model.displayValue.lowercased() {
                selectedIndex = index
                break
            }
        }
        self.teamPickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
    }
    
    @objc func doneClick() {
        txtFieldInput.resignFirstResponder()
    }
    @objc func cancelClick() {
        txtFieldInput.resignFirstResponder()
    }
    
    // MARK: UIPickerView Delegation
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teams.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teams[row].teamName
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtFieldInput.text = teams[row].teamName
        delegate?.valueChanged(forIndexPath: self.indexPath, newValue: teams[row].teamName)
        delegate?.setNewTeam(team: teams[row])
    }
    
}
