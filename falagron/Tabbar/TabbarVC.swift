//
//  TabbarVC.swift
//  falagron
//
//  Created by namik kaya on 27.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

enum PageState {
    case home, fallarim, purchase, notification, setting, profile
}

class TabbarVC: UITabBarController {
    
    static let shared: TabbarVC = {
        let instance = TabbarVC()
        return instance
    }()
    
    var setState:PageState? {
        didSet {
            guard let setState = setState else { return }
            switch setState {
            case .home:
                self.selectedIndex = 0
                break
            case .fallarim:
                self.selectedIndex = 1
                break
            case .purchase:
                self.selectedIndex = 2
                break
            case .notification:
                self.selectedIndex = 3
                break
            case .setting:
                self.selectedIndex = 4
                break
            case .profile:
                self.selectedIndex = 5
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        setupTabbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        deeplinkPerform()
    }
}


extension TabbarVC {
    private func setupTabbar() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNC") as? MainNC {
            self.viewControllers = [vc]
        }
    }
}

extension TabbarVC {
    private func deeplinkPerform() {
        
    }
}
