//
//  KYSpinnerButton.swift
//  KYSpinnerButton
//
//  Created by namik kaya on 2.01.2021.
//

import UIKit

// MARK: - Delegates
protocol KYSpinnerButtonDelegate:AnyObject {
    func KYSpinnerButtonEvent(type: KYSpinnerButton.KYSpinnerButtonStatusType)
}
extension KYSpinnerButtonDelegate {
    func KYSpinnerButtonEvent(type: KYSpinnerButton.KYSpinnerButtonStatusType) { }
}

//MARK: - Enum Types
extension KYSpinnerButton {
    enum KYShapeType {
        case inside
        case middle
        case outside
        
        var animationDuration:Double {
            switch self {
            default: return 0.7
            }
        }
        
        var animationStroke:Double {
            switch self {
                default: return 0.6
            }
        }
        
        var animationName: String {
            switch self {
            case .inside:
                return "inside"
            case .middle:
                return "middle"
            case .outside:
                return "outside"
            }
        }
        
        var animationToValue: CGFloat {
            switch self {
            case .inside:
                return -(CGFloat.pi*2)
            case .middle:
                return (CGFloat.pi*2)
            case .outside:
                return -(CGFloat.pi*2)
            }
        }
    }
    enum KYUIType {
        case processing
        case normal
        
        var animationDuration:Double {
            switch self {
            default: return 0.4
            }
        }
        var quicklyDuration:Double {
            switch self {
            default: return 0.2
            }
        }
    }
    enum KYAnimationStatus {
        case openAnimationStart
        case openAnimationFinish
        case closeAnimationStart
        case closeAnimationFinish
    }
}

class KYSpinnerButton: UIButton {
    weak var delegate:KYSpinnerButtonDelegate?
    
//    MARK: - Types
    typealias KYSpinnerButtonStatusType = (tag:Int, status:KYAnimationStatus, button:KYSpinnerButton)
    typealias ShapeLayerGroup = (inside: CAShapeLayer, middle: CAShapeLayer, outside: CAShapeLayer)
    
//    MARK: - Views
    private var shapeLayerGroup:ShapeLayerGroup?
    private var shapeContainerView:UIView?
    private var contentMaskView:UIView?
    private var bgView:UIView?
    
//    MARK: - Event Holder
    private var eventListenerHolder: ((_ status:KYAnimationStatus)->Void)?
    
//    MARK: - Variables
    private var firstRunFlag:Bool = false
    private var selfViewFrame: CGRect!
    private var setCorner: CGFloat = 0 {
        didSet{
            if let bgView = bgView, let contentMaskView = contentMaskView, !firstRunFlag {
                bgView.layer.cornerRadius = setCorner
                bgView.layoutIfNeeded()
                contentMaskView.layer.cornerRadius = setCorner
                contentMaskView.layoutIfNeeded()
                firstRunFlag = true
            }
        }
    }
    
    @IBInspectable
    var outsideShapeColor: UIColor = .darkGray {
        didSet{
            if shapeLayerGroup != nil {
                shapeLayerGroup?.outside.strokeColor = outsideShapeColor.cgColor
            }
        }
    }
    
    @IBInspectable
    var middleShapeColor: UIColor = .darkGray {
        didSet{
            if shapeLayerGroup != nil {
                shapeLayerGroup?.middle.strokeColor = middleShapeColor.cgColor
            }
        }
    }
    
    @IBInspectable
    var insideShapeColor: UIColor = .darkGray {
        didSet{
            if shapeLayerGroup != nil {
                shapeLayerGroup?.inside.strokeColor = insideShapeColor.cgColor
            }
        }
    }
    
    var setStatus: KYUIType = .normal {
        didSet {
            setStatus == .processing ? startAnimate() : stopAnimate()
        }
    }
    
//    MARK:- initalize
    override init(frame: CGRect) {
        super.init(frame: frame)
        selfViewFrame = self.bounds
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selfViewFrame = self.bounds
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCorner = self.layer.cornerRadius
        if selfViewFrame != self.bounds {
            selfViewFrame = self.bounds
            firstRunFlag = false
            setup()
            setCorner = self.layer.cornerRadius
            self.titleLabel?.layer.zPosition = 1
            bgView?.layer.zPosition = 0
            shapeContainerView?.layer.zPosition = 2
        }
    }
    
    deinit {
        shapeLayerGroup = nil
        shapeContainerView?.removeFromSuperview()
        shapeContainerView = nil
        
        contentMaskView?.removeFromSuperview()
        contentMaskView = nil
        
        bgView?.removeFromSuperview()
        bgView = nil
        
        self.eventListenerHolder = nil
        self.removeShapeLayer()
        self.layer.removeAllAnimations()
        self.layer.removeFromSuperlayer()
    }
}

// MARK: - Setup & Events
extension KYSpinnerButton {
    private func setup() {
        let usedSize:CGFloat = self.selfViewFrame.size.height < self.selfViewFrame.size.width ? self.selfViewFrame.size.height : self.selfViewFrame.size.width
        
        //setCorner = self.layer.cornerRadius
        
        if bgView != nil {
            self.backgroundColor = bgView?.backgroundColor
            bgView?.removeFromSuperview()
            bgView = nil
        }
        
        if shapeLayerGroup != nil {
            shapeLayerGroup?.inside.removeAllAnimations()
            shapeLayerGroup?.inside.removeFromSuperlayer()
            shapeLayerGroup?.middle.removeAllAnimations()
            shapeLayerGroup?.middle.removeFromSuperlayer()
            shapeLayerGroup?.outside.removeAllAnimations()
            shapeLayerGroup?.outside.removeFromSuperlayer()
        }
        
        if shapeContainerView != nil {
            self.removeShapeLayer()
            shapeContainerView?.removeFromSuperview()
            shapeContainerView = nil
        }
        
        if contentMaskView != nil {
            contentMaskView?.removeFromSuperview()
            contentMaskView = nil
        }
        
        bgView = createView()
        bgView?.backgroundColor = self.backgroundColor
        self.addSubview(bgView!)
        bgView?.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.clear
        
        shapeContainerView = createView()
        shapeContainerView?.isHidden = true
        shapeContainerView?.alpha = 0
        self.addSubview(shapeContainerView!)
        
        shapeLayerGroup = createShapeGroup(size: usedSize)
        contentMaskView = createView()
        contentMaskView?.backgroundColor = .black
        contentMaskView?.isUserInteractionEnabled = false
        self.addSubview(contentMaskView!)
        self.mask = contentMaskView
        
        if setStatus == .processing { startAnimate() }
    }
    func eventListener(event: @escaping (_ status: KYAnimationStatus) -> ()) {
        self.eventListenerHolder = event
    }
}

// Animation Control
extension KYSpinnerButton {
    private func startAnimate() {
        self.titleLabel?.isHidden = true
        self.isUserInteractionEnabled = false
        startViewAnimation()
    }
    private func stopAnimate() {
        self.titleLabel?.isHidden = false
        self.isUserInteractionEnabled = true
        stopViewAnimation()
    }
    private func startViewAnimation() {
        startShapeAnimate()
        
        eventListenerHolder?(.openAnimationStart)
        delegate?.KYSpinnerButtonEvent(type: (tag: self.tag, status: .openAnimationStart, button: self))
        shapeContainerView?.alpha = 0
        shapeContainerView?.isHidden = false
        shapeContainerView?.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.titleLabel?.isHidden = true
        UIView.animate(withDuration: KYUIType.processing.animationDuration) { [weak self] in
            guard let contentMaskView = self?.contentMaskView, let bgView = self?.bgView, let shapeContainerView = self?.shapeContainerView  else { return }
            contentMaskView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            contentMaskView.frame = CGRect(x: ((self?.selfViewFrame.size.width)! - bgView.frame.size.height) / 2,
                                           y: 0, width: bgView.frame.size.height, height: bgView.frame.size.height)
            contentMaskView.layer.cornerRadius = bgView.frame.size.height / 2
            contentMaskView.layoutIfNeeded()
            
            bgView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            bgView.frame = CGRect(x: ((self?.selfViewFrame.size.width)! - bgView.frame.size.height) / 2,
                                  y: 0, width: bgView.frame.size.height, height: bgView.frame.size.height)
            bgView.layer.cornerRadius = bgView.frame.size.height / 2
            bgView.layoutIfNeeded()
            
            shapeContainerView.transform = CGAffineTransform(scaleX: 1, y: 1)
            shapeContainerView.alpha = 1
        } completion: { (act) in
            self.eventListenerHolder?(.openAnimationFinish)
            self.delegate?.KYSpinnerButtonEvent(type: (tag: self.tag, status: .openAnimationFinish, button: self))
            self.titleLabel?.isHidden = true
            self.shapeContainerView?.isHidden = false
            self.shapeContainerView?.alpha = 1
        }
        
        UIView.animate(withDuration: KYUIType.processing.quicklyDuration) { [weak self] in
            self?.titleLabel?.alpha = 0
        } completion: { (act) in
            
        }
    }
    private func stopViewAnimation() {
        stopShapeAnimate()
        
        eventListenerHolder?(.closeAnimationStart)
        delegate?.KYSpinnerButtonEvent(type: (tag: self.tag, status: .closeAnimationStart, button: self))
        UIView.animate(withDuration: KYUIType.normal.animationDuration) { [weak self] in
            guard let contentMaskView = self?.contentMaskView, let bgView = self?.bgView, let shapeContainerView = self?.shapeContainerView  else { return }
            contentMaskView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            contentMaskView.frame = CGRect(x: 0, y: 0, width: (self?.selfViewFrame.size.width)!, height: (self?.selfViewFrame.size.height)!)
            contentMaskView.layer.cornerRadius = 0
            contentMaskView.layoutIfNeeded()
            
            bgView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            bgView.frame = CGRect(x: 0, y: 0, width: (self?.selfViewFrame.size.width)!, height: (self?.selfViewFrame.size.height)!)
            bgView.layer.cornerRadius = self?.setCorner ?? 0
            bgView.layoutIfNeeded()
            
            shapeContainerView.transform = CGAffineTransform(scaleX: 0, y: 0)
            shapeContainerView.alpha = 0
        } completion: { (act) in
            self.eventListenerHolder?(.closeAnimationFinish)
            self.delegate?.KYSpinnerButtonEvent(type: (tag: self.tag, status: .closeAnimationFinish, button: self))
            self.shapeContainerView?.isHidden = true
            self.shapeContainerView?.alpha = 0
        }
        
        self.titleLabel?.isHidden = false
        self.titleLabel?.alpha = 0
        UIView.animate(withDuration: KYUIType.normal.quicklyDuration) { [weak self] in
            self?.titleLabel?.alpha = 1
        } completion: { (act) in
            
        }
    }
}
// create material
extension KYSpinnerButton {
    private func createShapeGroup(size: CGFloat) -> ShapeLayerGroup? {
        guard let shapeContainerView = shapeContainerView else { return nil }
        let size = size - 8
        let diff:CGFloat = size * 4 / 20
        
        let outsideRadius = size / 2
        let outsideLayer = createShapeLayers(radius: outsideRadius, color: outsideShapeColor, clockwise: true)
        outsideLayer.position = getPosition(_layer: outsideLayer)
        shapeContainerView.layer.addSublayer(outsideLayer)
        
        let middleRadius = (size - diff) / 2
        let middleLayer = createShapeLayers(radius: middleRadius, color: middleShapeColor, clockwise: true)
        middleLayer.position = getPosition(_layer: middleLayer)
        shapeContainerView.layer.addSublayer(middleLayer)
        
        let insideRadius = (size - diff * 2) / 2
        let insideLayer = createShapeLayers(radius: insideRadius, color: insideShapeColor, clockwise: true)
        insideLayer.position = getPosition(_layer: insideLayer)
        shapeContainerView.layer.addSublayer(insideLayer)
        
        shapeLayerGroup = ShapeLayerGroup(inside: insideLayer, middle: middleLayer, outside: outsideLayer)
        return shapeLayerGroup!
    }
    private func createShapeLayers(radius:CGFloat, color:UIColor, clockwise:Bool) -> CAShapeLayer {
        let cirPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: clockwise)
        let shape = CAShapeLayer()
        shape.path = cirPath.cgPath
        shape.lineCap = CAShapeLayerLineCap.round
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = color.cgColor
        shape.lineWidth = radius * 2 / 20
        return shape
    }
    private func getPosition(_layer: CAShapeLayer) -> CGPoint {
        return CGPoint(x: (self.selfViewFrame.size.width - _layer.frame.size.width) / 2,
                       y: (self.selfViewFrame.size.height - _layer.frame.size.height) / 2)
    }
    private func removeShapeLayer() {
        if shapeLayerGroup != nil {
            clearAnimation()
            shapeLayerGroup?.inside.removeFromSuperlayer()
            shapeLayerGroup?.middle.removeFromSuperlayer()
            shapeLayerGroup?.outside.removeFromSuperlayer()
            shapeLayerGroup = nil
        }
    }
    private func createView() -> UIView {
        let view = UIView(frame: self.selfViewFrame)
        return view
    }
}
// Shape animation
extension KYSpinnerButton {
    private func startShapeAnimate() {
        clearAnimation()
        
        guard let shapeLayerGroup = shapeLayerGroup else { return }
        
        shapeLayerGroup.outside.strokeEnd = 0.6
        let rotationOutside : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationOutside.toValue = KYShapeType.outside.animationToValue
        rotationOutside.duration = KYShapeType.outside.animationDuration
        rotationOutside.isCumulative = true
        rotationOutside.fillMode = CAMediaTimingFillMode.forwards
        rotationOutside.repeatCount = Float.greatestFiniteMagnitude
        rotationOutside.isRemovedOnCompletion = false
        shapeLayerGroup.outside.add(rotationOutside, forKey: KYShapeType.outside.animationName)
        
        shapeLayerGroup.middle.strokeEnd = 0.6
        let rotationMiddle : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationMiddle.toValue = KYShapeType.middle.animationToValue
        rotationMiddle.duration = KYShapeType.middle.animationDuration
        rotationMiddle.isCumulative = true
        rotationMiddle.fillMode = CAMediaTimingFillMode.forwards
        rotationMiddle.repeatCount = Float.greatestFiniteMagnitude
        rotationMiddle.isRemovedOnCompletion = false
        shapeLayerGroup.middle.add(rotationMiddle, forKey: KYShapeType.middle.animationName)
        
        shapeLayerGroup.inside.strokeEnd = 0.6
        let rotationInside : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationInside.toValue = KYShapeType.inside.animationToValue
        rotationInside.duration = KYShapeType.inside.animationDuration
        rotationInside.isCumulative = true
        rotationInside.fillMode = CAMediaTimingFillMode.forwards
        rotationInside.repeatCount = Float.greatestFiniteMagnitude
        rotationInside.isRemovedOnCompletion = false
        shapeLayerGroup.inside.add(rotationInside, forKey: KYShapeType.inside.animationName)
    }
    private func stopShapeAnimate() {
        clearAnimation()
    }
    private func clearAnimation() {
        shapeLayerGroup?.inside.removeAllAnimations()
        shapeLayerGroup?.middle.removeAllAnimations()
        shapeLayerGroup?.outside.removeAllAnimations()
    }
}
