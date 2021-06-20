//
//  ResetViewModel.swift
//  falagron
//
//  Created by namik kaya on 18.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

class ResetViewModel: NSObject {
    private var resetServiceManager:ResetServiceManager?
    override init() {
        super.init()
        resetServiceManager = ResetServiceManager()
    }
    var reloadViewClosure: ((_ emailAddress:String?, _ errorMessage:String?) -> ())?
    
    
}

extension ResetViewModel {
    func sendResetService(email address:String?) {
        guard let email = address, checkEmailValid(mail: email) else {
            reloadViewClosure?(nil, "E-posta adresinde bir hata var. Lütfen kontrol edip tekrar deneyin.")
            return
        }
        callResetService(email: email)
    }
}

extension ResetViewModel {
    private func checkEmailValid(mail:String?) -> Bool {
        if let trimMail = mail?.trimmingCharacters(in: .whitespacesAndNewlines)  {
            return trimMail.isEmail()
        }else {
            return false
        }
    }
}

extension ResetViewModel {
    private func callResetService(email:String) {
        resetServiceManager?.sendEmailAddress(email: email, completion: { [weak self] (status:Bool, errorMessage:String?) in
            if status {
                self?.reloadViewClosure?(email, nil)
            }else {
                self?.reloadViewClosure?(nil, errorMessage ?? "Bir hata oluştu")
            }
        })
    }
}
