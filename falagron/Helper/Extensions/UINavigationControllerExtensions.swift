//
//  UINavigationControllerExtensions.swift
//  falagron
//
//  Created by namik kaya on 15.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import Foundation

extension UINavigationController {
    func pushToViewController(_ viewController: UIViewController, animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func popViewController(animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: true)
        CATransaction.commit()
    }
    
    func popToViewController(_ viewController: UIViewController, animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popToViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func popToRootViewController(animated:Bool = true, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popToRootViewController(animated: animated)
        CATransaction.commit()
    }
}

extension UINavigationController {
    internal func navigationBarSetup() {
        self.navigationBar.barTintColor = .clear
        self.navigationBar.isTranslucent = true
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationBar.layoutIfNeeded()
        self.navigationItem.backBarButtonItem?.tintColor = .white
        self.navigationBar.tintColor = .white
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Roboto", size: 16), NSAttributedString.Key.foregroundColor: UIColor.orange]
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
    }
}

extension UINavigationController {
    var getCurrentVC:UIViewController? {
        guard let viewController = UIViewController.topMostViewController() else { return nil }
        return viewController
    }
}
