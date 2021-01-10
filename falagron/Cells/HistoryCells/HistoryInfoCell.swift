//
//  HistoryInfoCell.swift
//  falagron
//
//  Created by namik kaya on 27.12.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class HistoryInfoCell: UITableViewCell {
    @IBOutlet private weak var bgView: UIView! {
        didSet {
            bgView.addDropShadow(cornerRadius: 8,
                                 shadowRadius: 4,
                                 shadowOpacity: 0.2,
                                 shadowColor: UIColor.black,
                                 shadowOffset: .zero)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(falData:String) {
        
    }
    
}
