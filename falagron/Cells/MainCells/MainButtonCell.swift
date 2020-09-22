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
    @IBOutlet private weak var iconImage: UIImageView!
    var type: PurchaseType?
    
    @IBOutlet private weak var contentContainer: UIView! {
        didSet {
            contentContainer.addDropShadow(cornerRadius: 8,
                                           shadowRadius: 3,
                                           shadowOpacity: 0.2,
                                           shadowColor: .lightGray,
                                           shadowOffset: .zero)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(title:String, image:UIImage, type: PurchaseType) {
        titleLabel.text = title
        iconImage.image = image
        self.type = type
    }
    
}
