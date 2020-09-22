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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkStartingViewController()
    }
    
    func getCurrentVC() -> UIViewController? {
        guard let viewController = UIViewController.topMostViewController() else { return nil }
        return viewController
    }
}

extension AuthenticationNC {
    func checkStartingViewController() {
        if let type = setRootViewControllerType {
            switch type {
            case .login:
                if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController {
                    self.setViewControllers([loginVC], animated: false)
                }
                break
            case .register:
                if let RegisterVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterViewController {
                    self.setViewControllers([RegisterVC], animated: false)
                }
                break
            case .otp:
                if let OTPVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as? OTPViewController {
                    self.setViewControllers([OTPVC], animated: false)
                }
                break
            case .reset:
                if let ResetVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetVC") as? ResetViewController {
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
    }
}
