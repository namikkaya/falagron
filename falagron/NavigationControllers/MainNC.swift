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
            vc.modalPresentationStyle = .formSheet
            present(vc, animated: true, completion: nil)
        }
    }
}
