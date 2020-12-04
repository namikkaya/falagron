//
//  SplashScreenVC.swift
//  falagron
//
//  Created by namik kaya on 15.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class SplashScreenVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    // user bilgisi geldikten sonra yönlendirme yaptırılıyor.
    override func userAuthStatusChange(status: FirebaseManager.FBAuthStatus) {
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 2) {
            self.goto(screenID: "SWRevealVC",
                      animated: true,
                      data: nil,
                      isModal: true)
        }
    }
}
