//
//  AddTextCell.swift
//  falagron
//
//  Created by namik kaya on 20.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class AddTextCell: UICollectionViewCell {

    @IBOutlet private weak var contentContainer: UIView!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var titleLabel: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.delegate = self
    }

    func setup(placeHolder:String?, addText:String? = "", icon:UIImage?, tag:Int) {
        titleLabel.tag = tag
        titleLabel.placeholder = placeHolder ?? ""
        self.icon.image = icon
    }
    
    
}

extension AddTextCell:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
}
