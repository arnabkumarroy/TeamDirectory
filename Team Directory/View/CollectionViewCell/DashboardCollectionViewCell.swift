//
//  DashboardCollectionViewCell.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "DashboardCollectionViewCell"
    
    @IBOutlet weak var imgView: UIImageView!
    
    private var team:Team!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTeamStregth: UILabel!
    @IBOutlet weak var lblTeamName: UILabel!
    
    override func awakeFromNib() {
        setUpUI()
    }
    
    func setUpUI(){
        self.layer.cornerRadius = 10.0
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        //self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    func configure(withModel model:Team){
        self.team = model
        self.lblTeamName.text = model.teamName
        self.lblDescription.text = "Description : \(model.teamDesc)"
        
        if model.teamMembers.count == 0 {
            self.lblTeamStregth.text = "No members added to the team"
            self.contentView.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
        } else {
            self.contentView.backgroundColor = UIColor.groupTableViewBackground
            let count = String(describing: model.teamMembers.count)
            self.lblTeamStregth.text = "Team strength : \(count) members"
        }
    }
}

