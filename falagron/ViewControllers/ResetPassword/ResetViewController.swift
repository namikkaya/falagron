//
//  ResetViewController.swift
//  falagron
//
//  Created by namik kaya on 19.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class ResetViewController: AuthenticationBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarTitle(titleText: "Şifre Sıfırla")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let closeButton = closeButtonSetup()
        closeButton.addTarget(self, action: #selector(closeButtonEvent(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func closeButtonEvent(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
