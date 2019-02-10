//
//  DashBoardViewController.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit

class DashBoardViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let dataBaseManager = FireBaseServiceManager()
    
    var teams = [Team]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.setUpNavigationBarButtonItems()
        UIViewController.showActivityIndicator()
        self.fetchTeams()
        self.registerNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationItem.setHidesBackButton(true, animated:false)
    }
    
    private func configureView() {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Teams"
    }
    
    private func setUpNavigationBarButtonItems() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "addCircle"), for: .normal)
        button.addTarget(self, action: #selector(showOptionMenu), for: UIControl.Event.touchDown)
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 53)
        let addTeamButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = addTeamButton
        let buttonLogOut = UIButton(type: .custom)
        buttonLogOut.setImage(UIImage(named: "logout"), for: .normal)
        buttonLogOut.addTarget(self, action: #selector(doLogOut), for: UIControl.Event.touchDown)
        buttonLogOut.frame = CGRect(x: 0, y: 0, width: 53, height: 53)
        let logOutBtn = UIBarButtonItem(customView: buttonLogOut)
        self.navigationItem.leftBarButtonItem = logOutBtn
    }
    
    @objc private func showOptionMenu() {
        self.performSegue(withIdentifier: "showOption", sender: self)
    }
    
    @objc func doLogOut(){
        AuthenticationManager.signOut(completion: {_ in })
        self.performSegue(withIdentifier: "homescreen", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let teamViewController = segue.destination as? TeamViewController , let team = sender as? Team {
            teamViewController.selectedTeam = team
            teamViewController.availableTeams = self.teams
        } else if segue.identifier == "showOption" {
            let optionViewController = (segue.destination as? UINavigationController)?.viewControllers.first as? OptionViewController
            optionViewController?.teams = self.teams
        }
    }
    
    private func fetchTeams() {
        dataBaseManager.readTeams { teams in
            self.teams = teams!
            DispatchQueue.main.async {
                UIViewController.hideActivityIndicator()
                self.collectionView.reloadData()
            }
        }
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notifyPendingDashboardRefresh),
            name: NSNotification.Name(rawValue: "reloadDashboardNotification"),
            object: nil)
    }
    
    @objc func notifyPendingDashboardRefresh() {
        self.fetchTeams()
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name(rawValue: "reloadDashboardNotification"),
            object: nil)
    }
    
    deinit {
        removeNotifications()
    }
    
}

extension DashBoardViewController : UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return teams.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: DashboardCollectionViewCell.reuseIdentifier, for: indexPath) as? DashboardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(withModel: teams[indexPath.row])
        
        return cell
        
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
}

extension DashBoardViewController : UICollectionViewDelegate{
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath){
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath)as? DashboardCollectionViewCell {
                cell.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath){
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? DashboardCollectionViewCell {
                cell.transform = .identity
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "TeamViewController", sender: teams[indexPath.row])
    }
}

extension DashBoardViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width - 30
        return CGSize(width: availableWidth, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
