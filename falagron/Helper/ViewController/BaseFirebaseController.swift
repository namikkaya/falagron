//
//  BaseFirebaseController.swift
//  falagron
//
//  Created by namik kaya on 18.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

class BaseFirebaseController: UIViewController {

    var authStatus: FirebaseManager.FBAuthStatus? = .singOut
    
    var loading:LoadingManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        loading = LoadingManager(target: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addListener()
        authStatus = FirebaseManager.shared.authStatus
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeListener()
        loading = nil
        authStatus = nil
    }
    
    func userAuthStatusChange(status:FirebaseManager.FBAuthStatus) {
        self.authStatus = status
    }
    
    func destory1() {
        print("XYZ: base view de destory base")
    }
    
    deinit {
        destory1()
        print("XYZ: base view de init")
    }
    
    
    func infoMessage(message:String = "", buttonTitle:String = "Tamam", completion: @escaping  () -> () = {}) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { (acion) in
            completion()
        }))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
}

extension BaseFirebaseController {
    func addListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.authStatusChange(_:)) , name: NSNotification.Name.FALAGRON.AuthChangeStatus, object: nil)
    }
    
    func removeListener() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.FALAGRON.AuthChangeStatus, object: nil)
    }
}

//MARK: - User Firebase Status
extension BaseFirebaseController {
    @objc private func authStatusChange(_ notification: Notification) {
        if let userInfo = notification.userInfo, let authStatus = userInfo["status"] as? FirebaseManager.FBAuthStatus {
            userAuthStatusChange(status: authStatus)
        }
    }
}
