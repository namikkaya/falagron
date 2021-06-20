//
//  ResetViewControlManager.swift
//  falagron
//
//  Created by namik kaya on 18.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

protocol ResetViewControlManagerDelegate:AnyObject {
    func resetEmailResponse(email: String?, errorMessage:String?)
}

extension ResetViewControlManagerDelegate {
    func resetEmailResponse(email: String?, errorMessage:String?) {}
}

class ResetViewControlManager: NSObject {
    weak var delegate: ResetViewControlManagerDelegate?
    
    private var viewModel: ResetViewModel?

    override init() {
        super.init()
        
    }
    
    convenience init(delegate: ResetViewControlManagerDelegate?) {
        self.init()
        self.delegate = delegate
        viewModel = ResetViewModel()
        viewModel?.reloadViewClosure = { [weak self] (email,errorMessage) in
            self?.delegate?.resetEmailResponse(email: email, errorMessage: errorMessage)
        }
    }
}

extension ResetViewControlManager {
    func resetCallService(email:String?) {
        viewModel?.sendResetService(email: email)
    }
}
