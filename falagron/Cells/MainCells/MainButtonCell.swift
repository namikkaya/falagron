//
//  MainButtonCell.swift
//  falagron
//
//  Created by namik kaya on 19.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class MainButtonCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImage: UIImageView! {
        didSet {
            iconImage.layer.masksToBounds = true
            iconImage.layer.cornerRadius = 4
        }
    }
    var type: PurchaseType?
    
    @IBOutlet private weak var contentContainer: UIView! {
        didSet {
            contentContainer.addDropShadow(cornerRadius: 8,
                                           shadowRadius: 3,
                                           shadowOpacity: 0.2,
                                           shadowColor: .black,
                                           shadowOffset: .zero)
            
            contentContainer.layer.borderWidth = 1
            contentContainer.layer.borderColor = UIColor(named: "defaultPurpleHolder")?.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layoutIfNeeded()
    }

    func setup(title:String, image:UIImage, type: PurchaseType) {
        titleLabel.text = title
        iconImage.image = image
        iconImage.contentMode = .scaleAspectFill
        
        
        self.type = type
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
