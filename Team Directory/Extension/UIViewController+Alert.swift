//
//  UIViewController+Alert.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import UIKit
import BRYXBanner

var activityHolderView: UIView!

var activityIndicator  = UIActivityIndicatorView()

var screenShot = UIImageView()

var isActivityViewDisplayed = false

typealias AlertCompletionHandler = ((_ index:AlertAction)->())?
typealias AlertCompletionHandlerInt = ((_ index:Int)->())


extension UIViewController {
    
    class func showActivityIndicator() {
        
        DispatchQueue.main.async {
            if  isActivityViewDisplayed == false {
                
                isActivityViewDisplayed = true
                activityHolderView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
                activityHolderView?.center = (UIApplication.shared.delegate?.window??.center)!
                activityHolderView.backgroundColor = UIColor.black
                activityHolderView.alpha = 0.4
                activityHolderView.layer.cornerRadius = 5.0
                
                UIApplication.shared.delegate?.window??.addSubview(activityHolderView)
                
                let basePoint = UIApplication.shared.delegate?.window??.convert(activityHolderView.frame.origin, from: UIWindow())
                activityHolderView.frame.origin = basePoint!
                
                activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
                activityIndicator.hidesWhenStopped = true
                activityIndicator.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
                activityIndicator.startAnimating()
                
                activityIndicator.center = activityHolderView.center
                UIApplication.shared.delegate?.window??.addSubview(activityIndicator)
                
                UIApplication.shared.delegate?.window??.isUserInteractionEnabled = false
                UIApplication.shared.delegate?.window??.alpha = 0.8
            }
            
        }
        
    }
    
    class func hideActivityIndicator() {
        DispatchQueue.main.async {
            if isActivityViewDisplayed == true {
                activityHolderView.removeFromSuperview()
                activityIndicator.removeFromSuperview()
                screenShot.removeFromSuperview()
                
                UIApplication.shared.delegate?.window??.isUserInteractionEnabled = true
                UIApplication.shared.delegate?.window??.alpha = 1.0
                isActivityViewDisplayed = false
            }
        }
    }
    
    func enableTapEndEditing(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideAllKeybaord))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideAllKeybaord(){
        self.view.endEditing(true)
    }
    
    func showErrorBanner(withTitle title:String,message:String) {
        let banner = Banner(title: title, subtitle: message, image: nil, backgroundColor: UIColor.red)
        banner.dismissesOnTap = true
        banner.show(duration: 2.0)
    }
    
    func showMessegeBanner(withTitle title:String,message:String) {
        let banner = Banner(title: title, subtitle: message, image: nil, backgroundColor: UIColor.magenta)
        banner.dismissesOnTap = true
        banner.show(duration: 2.0)
    }
    
    func showAlert(title:String?, message:String?, handler:AlertCompletionHandler = nil){
        
        let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Ok", style:.default, handler:{ (alert) in
            handler?(AlertAction.Ok)
        }))
        self.present(alert, animated: true)
    }
    
    func showAlertWithHandler(title:String?, message:String?, handler:AlertCompletionHandler){
        
        let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title:"Ok", style:.default, handler: { (alert) in
            handler?(AlertAction.Ok)
        }))
        
        alert.addAction(UIAlertAction(title:"Cancel", style:.default, handler: { (alert) in
            handler?(AlertAction.Cancel)
        }))
        self.present(alert, animated: true)
    }
    
    func showAlertWithHandler(title:String?, message:String?, okButtonTitle:String, cancelButtionTitle:String,handler:AlertCompletionHandler){
        
        let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title:okButtonTitle, style:.default, handler: { (alert) in
            handler?(AlertAction.Ok)
        }))
        
        alert.addAction(UIAlertAction(title:cancelButtionTitle, style:.default, handler: { (alert) in
            handler?(AlertAction.Cancel)
        }))
        
        self.present(alert, animated: true)
    }
    
    
    func showAlertWithHandler(title:String?, message:String?, buttonsTitles:[String], showAsActionSheet: Bool,handler:@escaping AlertCompletionHandlerInt){
        
        let alert = UIAlertController(title:title, message: message, preferredStyle: (showAsActionSheet ?.actionSheet : .alert))
        
        for btnTitle in buttonsTitles{
            alert.addAction(UIAlertAction(title:btnTitle, style:.default, handler: { (alert) in
                handler(buttonsTitles.index(of: btnTitle)!)
            }))
        }
        
        self.present(alert, animated: true)
    }
    
}

