//
//  RegisterHeaderView.swift
//  falagron
//
//  Created by namik kaya on 25.10.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class RegisterHeaderView: UIView {
    private var view:UIView!
    private var nibName:String = "RegisterHeaderView"
    @IBOutlet weak var titleText: UILabel!
    
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
    
    func setTitle(title:String) {
        titleText.text = title
    }
}
