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
