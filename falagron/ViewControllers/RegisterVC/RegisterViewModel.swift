//
//  RegisterViewModel.swift
//  falagron
//
//  Created by namik kaya on 9.04.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

class RegisterViewModel: NSObject {
    
    
    var reloadViewClosure: (()->())?
    
    override init() {
        super.init()
    }
    
    convenience init(type:String) {
        self.init()
    }
    
    
}
