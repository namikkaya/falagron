//
//  DateExtensions.swift
//  falagron
//
//  Created by namik kaya on 2.05.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import Foundation


extension Date {
    func convertDate(formate: String) -> String {
        let date = self//Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale(localeIdentifier: "tr") as Locale //localization language
        dateFormatter.dateFormat = formate
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }

}
