//
//  MenuFooterView.swift
//  falagron
//
//  Created by namik kaya on 11.10.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

protocol MenuFooterViewDelegate:class {
    func logoutButtonEvent()
}

extension MenuFooterViewDelegate {
    func logoutButtonEvent() {}
}

class MenuFooterView: UICollectionReusableView {
    private var view:UIView!
    private var nibName:String = "MenuFooterView"
    weak var delegate:MenuFooterViewDelegate?
    
    @IBOutlet weak var logInOutButton: UIButton!{
        didSet {
            logInOutButton.layer.cornerRadius = logInOutButton.frame.size.height / 2
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib()-> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    @IBAction func logoutButtonEvent(_ sender: Any) {
        delegate?.logoutButtonEvent()
    }
}
