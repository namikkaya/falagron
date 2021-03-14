//
//  LocalNotificationCenter.swift
//  falagron
//
//  Created by namik kaya on 13.01.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotificationCenter: NSObject {
    
    static let shared: LocalNotificationCenter = {
        let instance = LocalNotificationCenter()
        return instance
    }()
    
    override init() {
        super.init()
        
    }
    
}

// MARK: -Notification izinleri
extension LocalNotificationCenter {
    func checkLocalNotificationAuthorization (completion: @escaping  (_ granted:Bool, _ status:UNAuthorizationStatus?) -> () = {_, _ in}) {
        UNUserNotificationCenter.current().getNotificationSettings { (setting: UNNotificationSettings) in
            switch setting.authorizationStatus {
            case .authorized:
                // izin verilmiş
                //print("XYZ: authorized")
                completion(true, .authorized)
                break
            case .denied:
                // izin verilmemiş
                //print("XYZ: denied")
                completion(false, .denied)
                break
            case .notDetermined:
                // henuz bir izin belirtmedi
                //print("XYZ: notDetermined")
                completion(false, .notDetermined)
                break
            case .ephemeral:
                // ephemeral
                //print("XYZ: ephemeral")
                if #available(iOS 14.0, *) {
                    completion(true, .ephemeral)
                } else {
                    completion(true, .authorized)
                }
                break
            case .provisional:
                //print("XYZ: provisional")
                if #available(iOS 14.0, *) {
                    completion(true, .provisional)
                } else {
                    completion(true, .authorized)
                }
                break
            @unknown default: break
            }
        }
    }
    
    func requestNotificationAuthorization() {
        let options:UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (status: Bool, error: Error?) in
            if status {
                // izin verildi
                //print("XYZ: İzin verildi")
            }else {
                //print("XYZ: İzin verilmedi error: \(error?.localizedDescription ?? "--")")
            }
        }
    }
}

extension LocalNotificationCenter {
    func addScheduleNotification(at time: TimeInterval, uniqId:String, title:String, body:String, userInfo: [String:String]) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = 1
        content.sound = UNNotificationSound.default
        content.userInfo = userInfo
        content.categoryIdentifier = "RootNavigation"
        
        let request = UNNotificationRequest(identifier: uniqId, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("hatadan nefret ederim: \(error)")
            }
        }
    }
    
}
