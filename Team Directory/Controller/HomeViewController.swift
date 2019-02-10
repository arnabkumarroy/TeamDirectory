//
//  HomeViewController.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit

enum HomeScreenFlow {
    case signUp,signIn
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var imgViewLogo: UIImageView!
    
    @IBOutlet weak var txtFieldUserName: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    
    @IBOutlet weak var btnForgetPassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var uiswitchRememberMe: UISwitch!
    private let authenticationManager = AuthenticationManager()
    
    @IBOutlet weak var stackViewRemeberUserID: UIStackView!
    
    @IBOutlet weak var stackViewSignUp: UIStackView!
    
    var flow:HomeScreenFlow = .signIn
    static var doLauchAnimation = true
    
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if HomeViewController.doLauchAnimation {
            self.view.alpha = 0.0
            self.view.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
        self.setUpView()
        self.configureUIBasedOnFLow()
        self.setUpkeyBoardNotifications()
        self.enableTapEndEditing()
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.setUpRememberUID()
        if HomeViewController.doLauchAnimation {
            HomeViewController.doLauchAnimation = false
            UIView.animate(withDuration: 0.6) {
                self.view.transform = CGAffineTransform.identity
                self.view.alpha = 1.0
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    private func setUpView() {
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.btnLogin.roundCorners()
        
        self.txtFieldUserName.setIcon(UIImage(named: "userName") ?? UIImage())
        self.txtFieldPassword.setIcon(UIImage(named: "Password_Two") ?? UIImage())
        
        self.txtFieldUserName.setBorder()
        self.txtFieldPassword.setBorder()
        
        self.txtFieldUserName.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.txtFieldPassword.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.uiswitchRememberMe.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        
        self.topBar.setBackgroundImage(UIImage(), for: .default)
        self.topBar.shadowImage = UIImage()
        self.topBar.isTranslucent = true
    }
    
    func configureUIBasedOnFLow() {
        self.stackViewRemeberUserID.isHidden = self.flow != .signIn
        self.stackViewSignUp.isHidden = self.flow != .signIn
        self.btnForgetPassword.isHidden = self.flow != .signIn
        let title = self.flow == .signIn ? "Login" : "SignUp"
        self.btnLogin.setTitle(title, for: .normal)
        self.topBar.isHidden = self.flow == .signIn
    }
    
    func setUpRememberUID() {
        guard self.flow == .signIn else { return }
        guard let user =  UserSettings.getUserID() else {
            self.uiswitchRememberMe.isOn = false
            return
        }
        self.txtFieldUserName.text = user
        self.uiswitchRememberMe.isOn = true
    }
    
    @IBAction func signUp(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as? HomeViewController else {
            return
        }
        controller.flow = .signUp
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func signIn(_ sender: Any) {
        guard let email = self.txtFieldUserName.text, let pwd = self.txtFieldPassword.text ,!email.isEmpty, !pwd.isEmpty else {
            self.showErrorBanner(withTitle: "Error", message: "Please enter the user and password")
            return
        }
        UIViewController.showActivityIndicator()
        if flow == .signIn {
            authenticationManager.signIn(userName: email, password: pwd) { status in
                if status {
                    self.performSegue(withIdentifier: "login", sender: nil)
                    UIViewController.hideActivityIndicator()
                } else {
                    UIViewController.hideActivityIndicator()
                    self.showErrorBanner(withTitle: "Error", message: "Something went wrong,please try again")
                }
            }
        } else {
            guard let email = self.txtFieldUserName.text ,let  pwd = self.txtFieldPassword.text else {
                UIViewController.hideActivityIndicator()
                return
            }
            authenticationManager.signUp(withEmail: email, password: pwd) { (loginStatus,message) in
                UIViewController.hideActivityIndicator()
                if !loginStatus {
                    self.showAlert(title: "Error", message: message)
                } else {
                    self.showAlert(title: "Success", message: "Sign up success", handler: { _ in
                        self.disMissView(UIButton())
                    })
                }
            }
        }
    }
    
    @IBAction func rememberMe(_ sender: Any) {
        if uiswitchRememberMe.isOn {
            UserSettings.storeUserId(Id: txtFieldUserName.text ?? "")
        } else {
            UserSettings.clearUserID()
        }
    }
    
    @IBAction func disMissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setUpkeyBoardNotifications() {
    }
}
