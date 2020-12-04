//
//  TabbarVC.swift
//  falagron
//
//  Created by namik kaya on 27.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit
import AwaitToast
enum PageState:Int {
    case home = 0, fallarim, purchase, notification, setting, profile
}

class TabbarVC: UITabBarController {
    // kullanıcı henüz giriş yapmamış ise giriş yapana kadar bu id tutulur.
    var notLoginHolderSelectedIndex:Int?
    
    static let shared: TabbarVC = {
        let instance = TabbarVC()
        return instance
    }()
    
    var setState:PageState? {
        didSet {
            guard let setState = setState else { return }
            if !loginCheck(state: setState) {
                DataHolder.shared.currentPageType = nil
                return
            }
            switch setState {
            case .home:
                self.selectedIndex = setState.rawValue
                break
            case .fallarim:
                self.selectedIndex = setState.rawValue
                break
            case .purchase:
                self.selectedIndex = setState.rawValue
                break
            case .notification:
                self.selectedIndex = setState.rawValue
                break
            case .setting:
                self.selectedIndex = setState.rawValue
                break
            case .profile:
                self.selectedIndex = setState.rawValue
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        setupTabbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        deeplinkPerform()
    }
}

extension TabbarVC {
    private func loginCheck(state: PageState)->Bool {
        guard notLoginHolderSelectedIndex == nil && FirebaseManager.shared.authStatus == .singIn else {
            notLoginHolderSelectedIndex = state.rawValue
            self.selectedIndex = PageState.home.rawValue
            return false
        }
        return true
    }
}


extension TabbarVC {
    private func setupTabbar() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNC") as? MainNC {
            self.viewControllers = [vc]
        }
    }
    
}

extension TabbarVC {
    private func deeplinkPerform() {
        
    }
}

extension TabbarVC {
    func infoMessage(message:String = "", buttonTitle:String = "Tamam", completion: @escaping  () -> () = {}) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { (acion) in
            completion()
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func toastMessage(message:String = "Bir hata oluştu.") {
        let toast: Toast = Toast.default(text: message)
        toast.show()
    }
}
