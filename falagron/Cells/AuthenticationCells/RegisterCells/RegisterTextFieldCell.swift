//
//  RegisterTextFieldCell.swift
//  falagron
//
//  Created by namik kaya on 24.10.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit
class RegisterTextFieldCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    var type:RegisterViewController.InputType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(type: RegisterViewController.InputType, placeHolder:String) {
        self.type = type
        textField.placeholder = placeHolder
        textField.tag = type.getTagIndex
    }
    
    
}
