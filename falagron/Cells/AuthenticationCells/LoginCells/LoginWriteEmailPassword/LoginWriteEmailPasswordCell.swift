//
//  LoginWriteEmailPasswordCell.swift
//  falagron
//
//  Created by namik kaya on 24.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class LoginWriteEmailPasswordCell: UICollectionViewCell {

    @IBOutlet private weak var mailLabel: UITextField!
    @IBOutlet private weak var passwordText: UITextField!
    @IBOutlet private weak var rePasswordText: UITextField!
    
    @IBOutlet private weak var mailIcon: UIImageView!
    @IBOutlet private weak var passwordIcon: UIImageView!
    @IBOutlet private weak var repasswordIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(mailPlaceHolder:String, passwordPlaceHolder:String, rePasswordPlaceHolder: String) {
        mailLabel.placeholder = mailPlaceHolder
        passwordText.placeholder = passwordPlaceHolder
        rePasswordText.placeholder = rePasswordPlaceHolder
        
        mailIcon.image = CellType.email.getIcon
        passwordIcon.image = CellType.password.getIcon
        repasswordIcon.image = CellType.repassword.getIcon
    }
    
}

extension LoginWriteEmailPasswordCell {
    enum CellType {
        case email, password, repassword
        
        var getIcon:UIImage {
            switch self {
            case .email:
                return UIImage(named: "coffee") ?? UIImage()
            case .password:
                return UIImage(named: "coffee") ?? UIImage()
            case .repassword:
                return UIImage(named: "coffee") ?? UIImage()
            }
        }
    }
}
