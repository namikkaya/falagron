//
//  AuthenticationNC.swift
//  falagron
//
//  Created by namik kaya on 17.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class AuthenticationNC: UINavigationController {
    var setRootViewControllerType:AuthVCType?
    
    var currentVC:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkStartingViewController()
        navigationBarSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getCurrentVC() -> UIViewController? {
        guard let viewController = UIViewController.topMostViewController() else { return nil }
        return viewController
    }
    
    func goToController(gotoVC:AuthVCType) {
        guard let targetVC = gotoVC.getController, let currentVC = self.currentVC else { return }
        gotoTargetController(model: AuthCurrentToTarget(currentController: currentVC, targetController: targetVC))
    }
    
    private func gotoTargetController(model:AuthCurrentToTarget) {
        currentVC = model.targetController
        self.pushViewController(model.targetController, animated: true)
    }
}

extension AuthenticationNC {
    
    // navigasyonun hangi vc ile başlayacağını atar
    func checkStartingViewController() {
        if let type = setRootViewControllerType {
            switch type {
            case .login:
                if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController {
                    currentVC = loginVC
                    self.setViewControllers([loginVC], animated: false)
                }
                break
            case .register:
                if let RegisterVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterViewController {
                    currentVC = RegisterVC
                    self.setViewControllers([RegisterVC], animated: false)
                }
                break
            case .otp:
                if let OTPVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as? OTPViewController {
                    currentVC = OTPVC
                    self.setViewControllers([OTPVC], animated: false)
                }
                break
            case .reset:
                if let ResetVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetVC") as? ResetViewController {
                    currentVC = ResetVC
                    self.setViewControllers([ResetVC], animated: false)
                }
                break
            }
        }
    }
}

extension AuthenticationNC {
    enum AuthVCType {
        case login, register, otp, reset
        
        var getController:UIViewController? {
            switch self {
            case .login:
                let loginVC =  UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
                return loginVC
            case .register:
                let RegisterVC =  UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC") as? RegisterViewController
                return RegisterVC
            case .otp:
                let OTPVC =  UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "OTPVC") as? OTPViewController
                return OTPVC
            case .reset:
                let ResetVC =  UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "ResetVC") as? ResetViewController
                return ResetVC
            }
        }
        
        var getClassName:String {
            switch self {
            case .login:
                return LoginViewController.className
            case .register:
                return RegisterViewController.className
            case .otp:
                return OTPViewController.className
            case .reset:
                return ResetViewController.className
            }
        }
    }
}

extension AuthenticationNC {
    private func navigationBarSetup() {
        self.navigationBar.barTintColor = .clear
        self.navigationBar.isTranslucent = true
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationBar.layoutIfNeeded()
        self.navigationItem.backBarButtonItem?.tintColor = .white
        self.navigationBar.tintColor = .white
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Roboto", size: 16)]
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
    }
}
