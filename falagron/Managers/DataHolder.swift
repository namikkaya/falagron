//
//  DataHolder.swift
//  falagron
//
//  Created by namik kaya on 19.10.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class DataHolder: NSObject {
    static let shared: DataHolder = {
        let instance = DataHolder()
        return instance
    }()
    
    override init() {
        super.init()
    }
    
    var currentPageType:PageState = .home {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name.FALAGRON.ChangeCurrentPage, object: self, userInfo: nil)
            TabbarVC.shared.setState = currentPageType
        }
    }
}
