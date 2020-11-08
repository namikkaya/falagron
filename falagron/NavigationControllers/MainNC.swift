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
        if let vc = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "AuthenticationNC") as? AuthenticationNC {
            vc.setRootViewControllerType = .login
            if #available(iOS 13.0, *) {
                vc.modalPresentationStyle = .automatic
            } else {
                vc.modalPresentationStyle = .fullScreen
            }
            present(vc, animated: true, completion: nil)
        }
    }
}

extension MainNC {
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
