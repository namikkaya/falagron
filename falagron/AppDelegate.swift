//
//  AppDelegate.swift
//  falagron
//
//  Created by namik kaya on 15.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    /// Uygulamanın içindeyken tetiklendiğinde çalışır.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        var userInfo = notification.request.content.userInfo
        print("userNotificationCenter willPresent : \(userInfo) ")
        // si
        if userInfo["type"] == nil {
            userInfo["type"] = "silent"
        }
        AppNavigationCoordinator.shared.deeplinkEvent = userInfo
        completionHandler([.sound,.alert])
    }
    
    
    
    /// Notification geldiğinde bildirime tıklandığında tetiklenir.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        var userInfo = response.notification.request.content.userInfo
        // Print full message.
        print("userNotificationCenter didReceive : \(userInfo) ")
        if userInfo["type"] == nil {
            userInfo["type"] = "push"
        }
        AppNavigationCoordinator.shared.deeplinkEvent = userInfo
        completionHandler()
    }
}

