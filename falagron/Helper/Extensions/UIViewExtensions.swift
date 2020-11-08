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

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11, *) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            var masked = CACornerMask()
            if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
            if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
            if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
            if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
            self.layer.maskedCorners = masked
        }
        else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}
