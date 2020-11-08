//
//  StringExtensions.swift
//  falagron
//
//  Created by namik kaya on 21.10.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import Foundation

let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)

extension String {
    func isEmail() -> Bool {
        return __emailPredicate.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let password = self.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$" // Minimum 6 characters at least 1 Alphabet and 1 Number:
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)

    }
}

extension String {
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex...endIndex])
    }
}

