//
//  ResetViewController.swift
//  falagron
//
//  Created by namik kaya on 19.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class ResetViewController: AuthenticationBaseViewController {
    
    @IBOutlet private weak var contentContainer: UIView! {
        didSet {
            contentContainer.layer.cornerRadius = 4
        }
    }
    @IBOutlet private weak var emailLabel: UITextField!
    @IBOutlet private weak var resetButton: KYSpinnerButton!
    
    var resetViewControlManager: ResetViewControlManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarTitle(titleText: "Şifre Sıfırla")
        resetViewControlManager = ResetViewControlManager(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let closeButton = closeButtonSetup()
        closeButton.addTarget(self, action: #selector(closeButtonEvent(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func closeButtonEvent(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetButtonActionEvent(_ sender: Any) {
        if emailLabel.text?.count ?? 0 < 7 && emailLabel.isEmail(){
            DispatchQueue.main.async { [weak self] in
                self?.infoMessage(message: "Email adresinde hata olabilir. Lütfen kontrol edip tekrar deneyiniz", buttonTitle: "Tamam") { }
            }
        }else {
            resetViewControlManager?.resetCallService(email: emailLabel.text)
        }
    }
}

extension ResetViewController: ResetViewControlManagerDelegate {
    func resetEmailResponse(email: String?, errorMessage: String?) {
        if errorMessage == nil {
            DispatchQueue.main.async { [weak self] in
                self?.infoMessage(message: "Şifreniz değiştirme talebiniz başarı ile alındı. Lütfen eposta hesabınızı kontrol edin.", buttonTitle: "Tamam") {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }else {
            DispatchQueue.main.async { [weak self] in
                self?.infoMessage(message: errorMessage ?? "Bir hata oldu!", buttonTitle: "Tamam") { }
            }
        }
    }
}
