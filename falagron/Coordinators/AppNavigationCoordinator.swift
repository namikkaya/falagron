//
//  AppNavigationCoordinator.swift
//  falagron
//
//  Created by namik kaya on 9.01.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

enum PageState:Int, CaseIterable {
    case home = 0, fallarim, purchase, notification, setting, profile
    
    var getCheckName:String {
        switch self {
        case .home:
            return "home"
        case .fallarim:
            return "fallarim"
        case .purchase:
            return "purchase"
        case .notification:
            return "notification"
        case .setting:
            return "setting"
        case .profile:
            return "profile"
        }
    }
    
    static func getStringToState(name: String?) -> PageState? {
        guard let name = name else { return nil }
        for item in PageState.allCases {
            if item.getCheckName == name {
                return item
            }
        }
        return nil
    }
}

class AppNavigationCoordinator: NSObject {
    // Menu için;
    // kullanıcı henüz giriş yapmamış ise giriş yapana kadar bu id tutulur.
    var notLoginHolderSelectedIndex:Int?
    
    var deeplinkParser:DeepLinkParser?
    
    override init() {
        super.init()
    }
    
    static let shared: AppNavigationCoordinator = {
        let instance = AppNavigationCoordinator()
        return instance
    }()
    
    // Sol Menu Tablarda durur. Tab altında navigationController var
    var currentPageType:PageState? = .home {
        didSet {
            if currentPageType == nil { return }
            NotificationCenter.default.post(name: NSNotification.Name.FALAGRON.ChangeCurrentPage, object: self, userInfo: nil)
        }
    }
    
    var deeplinkEvent: [AnyHashable : Any]? {
        didSet{
            guard let deeplinkEvent = deeplinkEvent as? [String:String] else { return }
            deeplinkParser = DeepLinkParser(data: deeplinkEvent)
            NotificationCenter.default.post(name: NSNotification.Name.FALAGRON.DeeplinkEvent, object: self, userInfo: ["data":deeplinkParser as Any])
        }
    }
    
    func goToController(type: NavigationType, targetController:UIViewController) {
        switch type {
        case .Authentication(let openingVC):
            openingVC.goto(targetController: targetController)
            break
        }
    }
}

extension AppNavigationCoordinator {
    enum NavigationType {
        case Authentication(openingVC: AuthVCType)
        
//        MARK: - Kullanıcı bilgileri tipleri
        enum AuthVCType {
            case login(email: String?, password:String?), register, otp, reset
            
            // controller ları döner
            // Yeni bir sayfa eklendiğinde bu alana eklenecek
            var getController:UIViewController? {
                switch self {
                case .login:
                    let loginVC = getStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
                    return loginVC
                case .register:
                    let RegisterVC = getStoryBoard.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterViewController
                    return RegisterVC
                case .otp:
                    let OTPVC = getStoryBoard.instantiateViewController(withIdentifier: "OTPVC") as? OTPViewController
                    return OTPVC
                case .reset:
                    let ResetVC = getStoryBoard.instantiateViewController(withIdentifier: "ResetVC") as? ResetViewController
                    return ResetVC
                }
            }
            
            var getStoryBoard:UIStoryboard { return UIStoryboard(name: "Authentication", bundle: nil) }
            
            var getNavigation:AuthenticationNC? {
                switch self{
                case .login:
                    let addLoginPage = getStoryBoard.instantiateViewController(withIdentifier: "AuthenticationNC") as? AuthenticationNC
                    addLoginPage?.setRootViewControllerType = .login
                    return addLoginPage
                default:
                    return getStoryBoard.instantiateViewController(withIdentifier: "AuthenticationNC") as? AuthenticationNC
                }
            }
            
            func goto(targetController:UIViewController) {
                guard let nav = self.getNavigation else { return }
                if #available(iOS 13.0, *) {
                    nav.modalPresentationStyle = .automatic
                } else {
                    nav.modalPresentationStyle = .fullScreen
                }
                targetController.present(nav, animated: true, completion: nil)
            }
            
            func goto(targetNavigationController:UINavigationController) {
                guard let nav = self.getNavigation else { return }
                targetNavigationController.pushViewController(nav, animated: true)
            }
        }
        
        // --
        
    }
    
    enum PageOpeningDisplayType {
        case push, present
    }
}
