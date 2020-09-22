//
//  MainBannerCell.swift
//  falagron
//
//  Created by namik kaya on 19.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class MainBannerCell: UICollectionViewCell {
    @IBOutlet private weak var bannerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(image:UIImage) {
        bannerImage.image = image
    }
    
    
}
