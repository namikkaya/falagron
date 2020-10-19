//
//  MenuHeader.swift
//  falagron
//
//  Created by namik kaya on 11.10.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class MenuHeader: UICollectionReusableView {
    
    var myHeader:MenuHeaderView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        myHeader = MenuHeaderView(frame: frame)
        self.addSubview(myHeader)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        myHeader.frame = self.bounds
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
}
