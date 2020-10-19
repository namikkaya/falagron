//
//  menuCell.swift
//  falagron
//
//  Created by namik kaya on 11.10.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class menuCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImage: UIImageView!
    
    var data:MenuModel?
    override var isSelected: Bool {
        didSet{
            self.selectDisplayStatus(selected: isSelected)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(data:MenuModel) {
        iconImage.image = data.icon
        titleLabel.text = data.title
        self.data = data
    }
    
    func selectDisplayStatus(selected:Bool) {
        if selected {
            backgroundColor = UIColor.green
        }else {
            backgroundColor = UIColor.clear
        }
    }
}
