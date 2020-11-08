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
    @IBOutlet weak var bgView: UIView! {
        didSet {
            bgView.roundCorners(corners: [.topLeft, .bottomLeft], radius: bgView.frame.size.height/2 - 5)
        }
    }
    
    @IBOutlet weak var arrowIcon: UIImageView! {
        didSet {
            arrowIcon.image = UIImage(named: "rightArrow")
        }
    }
    var data:MenuModel?
    override var isSelected: Bool {
        didSet{
            self.selectDisplayStatus(selected: isSelected)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.roundCorners(corners: [.topLeft, .bottomLeft], radius: bgView.frame.size.height/2 - 5)
    }
    
    func setup(data:MenuModel) {
        iconImage.image = data.icon
        titleLabel.text = data.title
        self.data = data
    }
    
    func selectDisplayStatus(selected:Bool) {
        if selected {
            //bgView.backgroundColor = UIColor(named: "defaultYellow")
            bgView.backgroundColor = UIColor(named: "darkPurple")
            titleLabel.textColor = UIColor.white
            arrowIcon.image = UIImage(named: "rightArrowWhite")
        }else {
            bgView.backgroundColor = UIColor.white
            titleLabel.textColor = UIColor(named: "darkPurple")
            arrowIcon.image = UIImage(named: "rightArrow")
        }
    }
}
