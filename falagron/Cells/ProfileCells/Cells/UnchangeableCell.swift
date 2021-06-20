//
//  UnchangeableCell.swift
//  falagron
//
//  Created by namik kaya on 10.04.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

class UnchangeableCell: UITableViewCell {
    
    @IBOutlet private weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(email:String?) {
        emailLabel.text = "\(email ?? "")"
    }
}
