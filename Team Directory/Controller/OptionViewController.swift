//
//  OptionViewController.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit

class OptionViewController: UIViewController {
    
    @IBOutlet weak var tableViewOption: UITableView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    
    var teams = [Team]()
    
    let rows:[Action] = [.addTeam,.addTeamMember]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBlurEffect()
        self.setUpUI()
        //self.tapToDismiss()
        self.hideNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.insertSubview(blurEffectView, at: 0)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        view.insertSubview(vibrancyEffectView, at: 1)
    }
    
    private func setUpUI() {
        viewContainer.layer.cornerRadius = 10
        
        viewContainer.layer.shadowColor = UIColor.black.cgColor
        viewContainer.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        viewContainer.layer.shadowRadius = 1.0
        viewContainer.layer.shadowOpacity = 0.5
        viewContainer.layer.masksToBounds = false
        viewContainer.layer.shadowPath = UIBezierPath(roundedRect: viewContainer.bounds, cornerRadius: viewContainer.layer.cornerRadius).cgPath
        
        toolBar.layer.cornerRadius = 10
        toolBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        toolBar.clipsToBounds = true
        btnCancel.layer.cornerRadius = 10
        btnCancel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        btnCancel.clipsToBounds = true
    }
    
    private func tapToDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(disMissView))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func disMissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func hideNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension OptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let action = rows[indexPath.row]
        let teamDetaiViewController = TeamDetaiViewController.instantiate()
        teamDetaiViewController.flow = Flow(action: action, mode: .new)
        teamDetaiViewController.availableTeams = self.teams
        self.navigationController?.pushViewController(teamDetaiViewController, animated: true)
    }
}

extension OptionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionTableViewCell.identifier) as? OptionTableViewCell else {
            return UITableViewCell()
            
        }
        cell.lblTitle.text = rows[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension OptionViewController: LoadableViewController {
    static var storyboardFileName: String {
        return "Main"
    }
}

