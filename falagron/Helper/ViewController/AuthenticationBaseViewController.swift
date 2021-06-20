//
//  AuthenticationBaseViewController.swift
//  falagron
//
//  Created by namik kaya on 22.10.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class AuthenticationBaseViewController: BaseFirebaseController {
    internal var selfNC: AuthenticationNC?
    
    private var tap:UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selfNC = self.navigationController as? AuthenticationNC {
            self.selfNC = selfNC
        }
        tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.view.addGestureRecognizer(tap!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if tap != nil {
            self.view.removeGestureRecognizer(tap!)
        }
        self.selfNC = nil
    }

}

extension AuthenticationBaseViewController {
    internal func closeButtonSetup() -> UIButton {
        let standartImageButton = UIButton(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        standartImageButton.setImage(UIImage(named: "close"), for: .normal)
        //standartImageButton.setTitle("TEST", for: .normal)
        let item1 = UIBarButtonItem(customView: standartImageButton)
        let width = item1.customView?.widthAnchor.constraint(equalToConstant: 16)
        width?.isActive = true
        let height = item1.customView?.heightAnchor.constraint(equalToConstant: 16)
        height?.isActive = true
        self.navigationItem.setRightBarButton(item1, animated: true)
        return standartImageButton
    }
}
