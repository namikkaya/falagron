//
//  LoginViewController.swift
//  falagron
//
//  Created by namik kaya on 19.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class LoginViewController: AuthenticationBaseViewController {
    @IBOutlet private weak var contentContainer: UIView!
    @IBOutlet private weak var contentCenterConstraint: NSLayoutConstraint!
    @IBOutlet private weak var loginButton: KYSpinnerButton! {
        didSet{
            loginButton.addDropShadow(cornerRadius: 8,
                                      shadowRadius: 0,
                                      shadowOpacity: 0,
                                      shadowColor: .clear,
                                      shadowOffset: .zero)
        }
    }
    
    var isTakeKeyboard:Bool = false
    @IBOutlet private weak var emailText: UITextField! {
        didSet{
            emailText.delegate = self
            emailText.tag = 0
        }
    }
    @IBOutlet private weak var passwordText: UITextField! {
        didSet{
            passwordText.delegate = self
            passwordText.tag = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarTitle(titleText: "Giriş")
    }
    
    // user login and logout
    override func userAuthStatusChange(status: FirebaseManager.FBAuthStatus) {
        super.userAuthStatusChange(status: status)
        switch status {
        case .singIn:
            print("\(self.className) - Login")
            break
        case .singOut:
            print("\(self.className) - LogOut")
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        let closeButton = closeButtonSetup()
        closeButton.addTarget(self, action: #selector(closeButtonEvent(_:)), for: UIControl.Event.touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addKeyboardListener()
        emailText.becomeFirstResponder()
    }
    
    @objc private func closeButtonEvent(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
        // yönlendirme yapılmayacak. nil ataması yapılıyor.
        AppNavigationCoordinator.shared.notLoginHolderSelectedIndex = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardListener()
        self.view.endEditing(true)
    }
    
    @IBAction func registerButtonEvent(_ sender: Any) {
        guard let nc = self.selfNC else { return }
        nc.goToController(gotoVC: .register)
    }
    
    @IBAction func resetPasswordButtonEvent(_ sender: Any) {
        guard let nc = self.selfNC else { return }
        nc.goToController(gotoVC: .reset)
    }
    
    @IBAction func loginButtonEvent(_ sender: Any) {
        guard let email = emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines), email.isEmail() else {
            print("email hatası")
            self.infoMessage(message: "E-posta hatası! Lütfen kontrol edip tekrar deneyin.", buttonTitle: "Tamam") { }
            return
        }
        
        guard let password = passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines), password.isValidPassword() else {
            self.infoMessage(message: "Şifre hatası! Lütfen kontrol edip tekrar deneyin.", buttonTitle: "Tamam") { }
            return
        }
        loginButton.setStatus = .processing
        FirebaseManager.shared.singIn(email: email, password: password) { [weak self] (status, message) in
            self?.loginButton.setStatus = .normal
            guard status else {
                print("Hata döndü...")
                self?.infoMessage(message: message ?? "Bir hata oluştu", buttonTitle: "Tamam") { }
                return
            }
            
            
            self?.dismiss(animated: true, completion: {
                //dataholder a taşı.
                //TabbarVC.shared.toastMessage(message: "Hoşgeldin, \(FirebaseManager.shared.user?.displayName)")
            })
        }
    }
    
    
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let txtTag:Int = textField.tag
        if let textFieldNxt = self.view.viewWithTag(txtTag+1) as? UITextField {
            textFieldNxt.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
}

extension LoginViewController {
    private func addKeyboardListener () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardListener() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification:Notification) {
        if isTakeKeyboard { return }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            let center = self.view.frame.size.height / 2
            let newCenter = (self.view.frame.size.height - keyboardSize.height) / 2
            let newPosition = center - newCenter
            UIView.animate(withDuration: duration) {
                self.contentCenterConstraint.constant = -(newPosition-(newCenter/2) + 44)
                self.view.layoutIfNeeded()
                self.isTakeKeyboard = true
            }
        }
    }
    @objc private func keyboardWillHide(notification:Notification) {
        if !isTakeKeyboard { return }
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: duration) {
                self.contentCenterConstraint.constant = 0
                self.view.layoutIfNeeded()
                 self.isTakeKeyboard = false
            }
        }
    }
}
