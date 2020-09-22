//
//  BaseViewController.swift
//  falagron
//
//  Created by namik kaya on 15.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var authStatus: FirebaseManager.FBAuthStatus = .singOut
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController()?.delegate = self
        if let reconizer = self.revealViewController()?.panGestureRecognizer() {
            self.view.addGestureRecognizer(reconizer)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authStatus = FirebaseManager.shared.authStatus
    }
    
    
    func userAuthStatusChange(status:FirebaseManager.FBAuthStatus) {
        self.authStatus = status
    }
}
extension BaseViewController: SWRevealViewControllerDelegate {
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        switch position {
        case .left:
            
            break
        case .right:
            break
        default: break
        }
    }
}

//MARK: - Listener
extension BaseViewController {
    func addListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.authStatusChange(_:)) , name: NSNotification.Name.FALAGRON.AuthChangeStatus, object: nil)
    }
    
    func removeListener() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.FALAGRON.AuthChangeStatus, object: nil)
    }
}

//MARK: - User Firebase Status
extension BaseViewController {
    @objc private func authStatusChange(_ notification: Notification) {
        if let userInfo = notification.userInfo, let authStatus = userInfo["status"] as? FirebaseManager.FBAuthStatus {
            userAuthStatusChange(status: authStatus)
        }
    }
}
