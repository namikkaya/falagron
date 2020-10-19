//
//  BaseViewController.swift
//  falagron
//
//  Created by namik kaya on 15.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, SWRevealViewControllerDelegate {
    var authStatus: FirebaseManager.FBAuthStatus = .singOut
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authStatus = FirebaseManager.shared.authStatus
        self.revealViewController()?.delegate = self
        if let reconizer = self.revealViewController()?.panGestureRecognizer() {
            self.view.addGestureRecognizer(reconizer)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addListener()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeListener()
    }
    
    func userAuthStatusChange(status:FirebaseManager.FBAuthStatus) {
        self.authStatus = status
    }
    
    func menuDisplayChange(status:MenuDisplayStatus) { }
    
    @objc private func menuIsOpen(notification: Notification) {
        menuDisplayChange(status: .ON)
    }
    
    @objc private func menuIsClose(notification: Notification) {
        menuDisplayChange(status: .OFF)
    }
    
}

//MARK: - Listener
extension BaseViewController {
    func addListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.authStatusChange(_:)) , name: NSNotification.Name.FALAGRON.AuthChangeStatus, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.menuIsOpen) , name: NSNotification.Name.FALAGRON.MenuTakeOn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.menuIsClose) , name: NSNotification.Name.FALAGRON.MenuTakeOff, object: nil)
    }
    
    func removeListener() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.FALAGRON.AuthChangeStatus, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.FALAGRON.MenuTakeOn, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.FALAGRON.MenuTakeOff, object: nil)
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
