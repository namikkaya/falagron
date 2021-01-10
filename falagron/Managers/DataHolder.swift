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
    
}
