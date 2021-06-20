//
//  ResetServiceManager.swift
//  falagron
//
//  Created by namik kaya on 18.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

class ResetServiceManager: NSObject {
    
    override init() {
        super.init()
    }
    
    convenience init(user:String) {
        self.init()
    }
}

extension ResetServiceManager {
    func sendEmailAddress(email:String?, completion: @escaping (_ status:Bool, _ error: String?) -> () = {_, _ in}) {
        FirebaseManager.shared.resetPassword(email: email) { (status:Bool, errorMessage:String?) in
            completion(status, errorMessage)
        }
    }
}
