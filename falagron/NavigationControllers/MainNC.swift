//
//  MainNC.swift
//  falagron
//
//  Created by namik kaya on 18.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

enum PurchaseType {
    case daily // günlük
    case watcher // reklam izleyici kredisi
    case buyyer // direk satın alma
    case shared // Arkadaşlarıyla paylaşma
}

class MainNC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarSetup()
    }
    
    /*
    func getCurrentVC() -> UIViewController? {
        guard let viewController = UIViewController.topMostViewController() else { return nil }
        return viewController
    }*/
    
    func purchaseNavigation(type: PurchaseType) {
        switch type {
        case .daily:
            break
        case .buyyer:
            gotoLogin()
            break
        case .shared:
            break
        case .watcher:
            break
        }
    }
    
    func gotoLogin() {
        /*if let vc = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "AuthenticationNC") as? AuthenticationNC {
            vc.setRootViewControllerType = .login
            if #available(iOS 13.0, *) {
                vc.modalPresentationStyle = .automatic
            } else {
                vc.modalPresentationStyle = .fullScreen
            }
            present(vc, animated: true, completion: nil)
        }*/
        let sendType = AppNavigationCoordinator.NavigationType.Authentication(openingVC: .login(email: nil, password: nil))
        AppNavigationCoordinator.shared.goToController(type: sendType, targetController: self.getCurrentVC!)
    }
}
