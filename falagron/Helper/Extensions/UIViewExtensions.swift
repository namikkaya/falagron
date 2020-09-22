//
//  UIViewExtensions.swift
//  falagron
//
//  Created by namik kaya on 19.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import Foundation
extension UIView {
    func addDropShadow (cornerRadius: CGFloat = 10,
                     shadowRadius: CGFloat = 6,
                     shadowOpacity: Float = 0.3,
                     shadowColor: UIColor = UIColor.gray,
                     shadowOffset: CGSize = CGSize(width: 0, height:0)) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffset
    }
}
