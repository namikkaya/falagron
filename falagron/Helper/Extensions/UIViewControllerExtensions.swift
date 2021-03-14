//
//  UIViewControllerExtensions.swift
//  falagron
//
//  Created by namik kaya on 15.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import Foundation

private var dataAssocKey = 0
public var myHolderView:UIViewController?

extension UIViewController {
    
    var data:AnyObject? {
        get {
            return objc_getAssociatedObject(self, &dataAssocKey) as AnyObject?
        }
        set {
            objc_setAssociatedObject(self, &dataAssocKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func goto(screenID:String,
              animated:Bool,
              data:AnyObject? = nil,
              isModal:Bool,
              presentationStyle: UIModalPresentationStyle? = nil,
              transition: UIViewControllerTransitioningDelegate? = nil) {
        let vc:UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: screenID))!
        myHolderView = vc
        vc.data = data ?? nil
        if isModal == true {
            vc.modalPresentationStyle = presentationStyle ?? .overFullScreen
            vc.transitioningDelegate = transition ?? nil
            self.present(vc, animated: animated, completion:nil)
        }else {
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    static func topMostViewController() -> UIViewController? {
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return keyWindow?.rootViewController?.topMostViewController()
        }
        
        return UIApplication.shared.keyWindow?.rootViewController?.topMostViewController()
    }
    
    func topMostViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.topMostViewController()
        }
        else if let tabBarController = self as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return selectedViewController.topMostViewController()
            }
            return tabBarController.topMostViewController()
        }
            
        else if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
        
        else {
            return self
        }
    }
}

extension UIViewController{
    func showToast(message : String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}

extension UIViewController {
    internal func setNavigationBarTitle(titleText:String, fontSize: CGFloat = 16){
        //self.navigationItem.hidesBackButton = true
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Bold", size: 16)]
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        
        let textShadow = NSShadow()
        textShadow.shadowBlurRadius = 1
        textShadow.shadowOffset = CGSize(width: 0.2, height: 0.2)
        textShadow.shadowColor = UIColor.white
        
        let attrs = [
            NSAttributedString.Key.shadow: textShadow,
            NSAttributedString.Key.foregroundColor: UIColor.white, // UIColor.white
            NSAttributedString.Key.font: UIFont(name: "Roboto-Bold", size: fontSize)/*UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)*/
            //UIFont.systemFont(ofSize: 17)//UIFont(name: "Roboto-Bold", size: 17)!
        ]
        
        self.navigationController?.navigationBar.titleTextAttributes = attrs as [NSAttributedString.Key : Any]
        self.navigationItem.title = titleText
    }
}
