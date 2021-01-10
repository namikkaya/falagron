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
    
    var panGestureReconizer: UIPanGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addListener()
        authStatus = FirebaseManager.shared.authStatus
        self.revealViewController()?.delegate = self
        if authStatus == .singIn {
            if let recognizer = self.revealViewController()?.panGestureRecognizer() {
                panGestureReconizer = recognizer
                self.view.addGestureRecognizer(panGestureReconizer!)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.revealViewController()?.delegate = nil
        removeListener()
    }
    
    func userAuthStatusChange(status:FirebaseManager.FBAuthStatus) {
        if status == .singIn {
            if let reconizer = self.revealViewController()?.panGestureRecognizer() {
                panGestureReconizer = reconizer
                self.view.addGestureRecognizer(panGestureReconizer!)
            }
        }else {
            if panGestureReconizer != nil {
                self.view.removeGestureRecognizer(panGestureReconizer!)
            }
        }
        self.authStatus = status
    }
    
    func menuDisplayChange(status:MenuDisplayStatus) { }
    
    @objc private func menuIsOpen(notification: Notification) {
        menuDisplayChange(status: .ON)
    }
    
    @objc private func menuIsClose(notification: Notification) {
        menuDisplayChange(status: .OFF)
    }
    
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

extension BaseViewController: SWRevealViewControllerDelegate {
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        switch position {
        case .left:
            NotificationCenter.default.post(name: NSNotification.Name.FALAGRON.MenuTakeOff, object: self, userInfo: nil)
            break
        case .right:
            NotificationCenter.default.post(name: NSNotification.Name.FALAGRON.MenuTakeOn, object: self, userInfo: nil)
            break
        default: break
        }
    }
}

extension BaseViewController {
    func showUniversalLoadingView(_ show: Bool, loadingText : String = "") {
        let existingView = UIApplication.shared.windows[0].viewWithTag(1200)
        if show {
            if existingView != nil {
                return
            }
            let loadingView = self.makeLoadingView(withFrame: UIScreen.main.bounds, loadingText: loadingText)
            loadingView?.tag = 1200
            UIApplication.shared.windows[0].addSubview(loadingView!)
        } else {
            existingView?.removeFromSuperview()
        }
        
    }
    
    func makeLoadingView(withFrame frame: CGRect, loadingText text: String?) -> UIView? {
        let loadingView = UIView(frame: frame)
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        //activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = loadingView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .white
        activityIndicator.startAnimating()
        activityIndicator.tag = 100 // 100 for example
        
        loadingView.addSubview(activityIndicator)
        if !text!.isEmpty {
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
            let cpoint = CGPoint(x: activityIndicator.frame.origin.x + activityIndicator.frame.size.width / 2, y: activityIndicator.frame.origin.y + 80)
            lbl.center = cpoint
            lbl.textColor = UIColor.white
            lbl.textAlignment = .center
            lbl.text = text
            lbl.tag = 1234
            loadingView.addSubview(lbl)
        }
        return loadingView
    }
}
