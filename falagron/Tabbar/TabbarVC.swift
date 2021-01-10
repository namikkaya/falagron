//
//  TabbarVC.swift
//  falagron
//
//  Created by namik kaya on 27.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController {
    
    var setState:PageState? {
        didSet {
            guard let setState = setState else { return }
            if !loginCheck(state: setState) {
                AppNavigationCoordinator.shared.currentPageType = nil
                return
            }
            self.selectedIndex = setState.rawValue
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeState) , name: NSNotification.Name.FALAGRON.ChangeCurrentPage, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.FALAGRON.ChangeCurrentPage, object: nil)
    }
    
    @objc private func changeState(notification: Notification) {
        setState = AppNavigationCoordinator.shared.currentPageType
    }
}

extension TabbarVC {
    private func loginCheck(state: PageState)->Bool {
        guard AppNavigationCoordinator.shared.notLoginHolderSelectedIndex == nil && FirebaseManager.shared.authStatus == .singIn else {
            AppNavigationCoordinator.shared.notLoginHolderSelectedIndex = state.rawValue
            self.selectedIndex = PageState.home.rawValue
            return false
        }
        return true
    }
}


extension TabbarVC {
    private func setupTabbar() {
        if let mainNC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNC") as? MainNC,
           let historyNC = UIStoryboard(name: "History", bundle: nil).instantiateViewController(withIdentifier: "HistoryNC") as? HistoryNC {
            self.viewControllers = [mainNC, historyNC]
        }
    }
    
}

extension TabbarVC {
    private func deeplinkPerform() {
        
    }
}

extension TabbarVC {
    func infoMessage(message:String = "", buttonTitle:String = "Tamam", completion: @escaping  () -> () = {}) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { (acion) in
            completion()
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
