//
//  HolderTextField.swift
//  falagron
//
//  Created by namik kaya on 20.10.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class HolderTextField: UITextField {
    
    var setBgColor:UIColor? {
        didSet{
            self.backgroundColor = setBgColor
        }
    }
    var setBorderColor:UIColor = UIColor.lightGray {
        didSet{
            self.layer.borderColor = setBorderColor.cgColor
        }
    }
    var setBorderWidth:CGFloat = CGFloat(1) {
        didSet{
            self.layer.borderWidth = setBorderWidth
        }
    }
    var setCorner:CGFloat = CGFloat(8) {
        didSet{
            self.backgroundView?.layer.cornerRadius = setCorner
        }
    }
    var setTintColor:UIColor = UIColor.gray {
        didSet{
            self.tintColor = setTintColor
        }
    }
    var placeHolderBg:UIColor = UIColor.white {
        didSet{
            self.placeHolderLabel?.backgroundColor = placeHolderBg
        }
    }
    var placeHolderTextColor:UIColor = UIColor.lightGray {
        didSet{
            self.placeHolderLabel?.textColor = placeHolderTextColor
        }
    }
    private var placeHolderLabel:UILabel?
    private var backgroundView:UIView?
    private var animationStatus:IGTextFieldAnimationStatus = .deFocus
    private var animationFlag:Bool = false
    
    var _placeHolderHeight:CGFloat?
    var _ratioHeight:CGFloat?
    
    private let scaleRatio:CGFloat = 0.8
    
    enum IGTextFieldAnimationStatus {
        case focus
        case deFocus
    }
    
    override var text: String? {
        didSet {
            if let newText = text, !newText.isEmpty{
                animationFlag = false
                inTextAnimation(duration: 0.1)
            }else {
                emptyTextAnimation(duration: 0.1)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override var placeholder: String? {
        didSet{
            animationFlag = false
            placeHolderLabel?.text = " \(placeholder ?? "") "
            placeHolderLabel!.sizeToFit()
            
            _placeHolderHeight = placeHolderLabel?.bounds.size.height
            _ratioHeight = (_placeHolderHeight! * (scaleRatio*100)) / 100
            
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "" , attributes: [NSAttributedString.Key.foregroundColor: UIColor.clear])
            if let newText = text, !newText.isEmpty{
                inTextAnimation(duration: 0.1)
            }else {
                emptyTextAnimation(duration: 0.1)
            }
        }
    }
        
    private func setupUI() {
        self.backgroundColor = UIColor.clear
        self.tintColor = setTintColor
        
        backgroundView = UIView()
        backgroundView?.backgroundColor = setBgColor
        backgroundView?.layer.borderColor = setBorderColor.cgColor
        backgroundView?.layer.cornerRadius = setCorner
        backgroundView?.layer.borderWidth = setBorderWidth
        
        self.addSubview(backgroundView!)
        
        backgroundView?.isUserInteractionEnabled = false
        backgroundView!.translatesAutoresizingMaskIntoConstraints = false
        backgroundView?.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        backgroundView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundView?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        backgroundView?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        
        placeHolderLabel = UILabel()
        placeHolderLabel?.textColor = placeHolderTextColor
        placeHolderLabel?.adjustsFontSizeToFitWidth = true
        self.addSubview(placeHolderLabel!)
        
        placeHolderLabel?.backgroundColor = placeHolderBg
        placeHolderLabel?.text = placeholder
        placeHolderLabel?.textColor = placeHolderTextColor
        placeHolderLabel?.isUserInteractionEnabled = false
        placeHolderLabel?.setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
        
        placeHolderLabel!.translatesAutoresizingMaskIntoConstraints = false
        placeHolderLabel?.centerYAnchor.constraint(equalTo: backgroundView!.centerYAnchor).isActive = true
        placeHolderLabel?.leftAnchor.constraint(equalTo: self.backgroundView!.leftAnchor, constant: 8).isActive = true
        
        _placeHolderHeight = placeHolderLabel?.bounds.size.height
        _ratioHeight = (_placeHolderHeight! * 80) / 100
    }
    
    private func inTextAnimation(duration:Double? = 0.1){
        if animationFlag && animationStatus == .focus { return }
        animationFlag = true
        
        if let ratioHeight = _ratioHeight, let placeHolderHeight = _placeHolderHeight {
            let calc = (((placeHolderLabel?.frame.size.width)!*20)/100) / 2
            let secondScale = CGAffineTransform(scaleX: scaleRatio,y: scaleRatio)
            let secondTranslation = CGAffineTransform(translationX: -calc, y: -(ratioHeight + placeHolderHeight))
            let secondConcat = secondTranslation.concatenating(secondScale)
            UIView.animate(withDuration: duration ?? 0.2, animations: {
                self.placeHolderLabel!.transform = secondConcat
                self.layoutIfNeeded()
            }) { (act) in
                self.animationStatus = .focus
                self.animationFlag = false
            }
        }else {
             animationFlag = false
        }
    }
    
    private func emptyTextAnimation(duration:Double? = 0.1) {
        if animationFlag && animationStatus == .deFocus { return }
        animationFlag = true
        if let empty = self.text?.isEmpty, empty {
            UIView.animate(withDuration: duration ?? 0.2, animations: {
                self.placeHolderLabel!.transform = .identity
                self.layoutIfNeeded()
            }) { (act) in
                self.animationStatus = .deFocus
                self.animationFlag = false
            }
        }else {
            animationFlag = false
        }
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        emptyTextAnimation(duration: 0.1)
        return false
    }
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        inTextAnimation(duration: 0.1)
        return false
    }
    
    let padding = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8);
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}

extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
}
