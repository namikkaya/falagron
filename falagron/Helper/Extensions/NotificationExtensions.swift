//
//  NotificationExtensions.swift
//  falagron
//
//  Created by namik kaya on 19.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import Foundation

extension Notification.Name {
    public struct FALAGRON {
        public static let AuthChangeStatus = Notification.Name(rawValue: "auth_change_status")
        ///
        public static let MenuTakeOn = Notification.Name(rawValue: "menu_take_on")
        public static let MenuTakeOff = Notification.Name(rawValue: "menu_take_off")
        
        public static let ChangeCurrentPage = Notification.Name(rawValue: "change_current_page")
        
        public static let DeeplinkEvent = Notification.Name(rawValue: "deeplinkEvent")
    }
}
