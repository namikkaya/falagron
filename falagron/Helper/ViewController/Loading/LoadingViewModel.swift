//
//  LoadingViewModel.swift
//  falagron
//
//  Created by namik kaya on 6.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

protocol LoadingViewModelDelegate:class {
    func stopFinishComplete()
    func startFinishComplete()
}

class LoadingViewModel: NSObject {
    weak var delegate: LoadingViewModelDelegate?
    private var containerView:UIView! {
        didSet{
            containerView.isHidden = true
            containerView.layer.cornerRadius = 4
        }
    }
    private var indicator:UIActivityIndicatorView!
    
    override init() {
        super.init()
    }
    
    convenience init(containerView: UIView, indicator: UIActivityIndicatorView, delegate: LoadingViewModelDelegate) {
        self.init()
        self.containerView = containerView
        self.indicator = indicator
        self.delegate = delegate
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.start()
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.stop()
        }
    }
}

// animasyon kontrolleri
extension LoadingViewModel {
    private func stop() {
        self.containerView.layer.removeAllAnimations()
        self.containerView.alpha = 1
        self.containerView.isHidden = false
        self.containerView.transform = .identity
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform.init(translationX: 0, y: -40)
            self.containerView.layoutIfNeeded()
        } completion: { (act) in
            self.indicator.stopAnimating()
            self.containerView.isHidden = false
            self.containerView.transform = .identity
            self.delegate?.stopFinishComplete()
        }
    }
    
    private func start() {
        self.containerView.layer.removeAllAnimations()
        indicator.startAnimating()
        self.containerView.alpha = 0
        self.containerView.isHidden = false
        self.containerView.transform = CGAffineTransform.init(translationX: 0, y: +40)
        UIView.animate(withDuration: 0.4) {
            self.containerView.alpha = 1
            self.containerView.transform = .identity
            self.containerView.layoutIfNeeded()
        } completion: { (act) in
            self.delegate?.startFinishComplete()
        }
    }
}
