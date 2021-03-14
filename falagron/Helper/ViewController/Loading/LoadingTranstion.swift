//
//  LoadingTranstion.swift
//  falagron
//
//  Created by namik kaya on 7.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import Foundation

class LoadingTransition: NSObject,
UIViewControllerAnimatedTransitioning,
UIViewControllerTransitioningDelegate {
    
    private var presenting:Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if(presenting){
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
            let container = transitionContext.containerView
            
            let duration = self.transitionDuration(using: transitionContext)
            //let duration:TimeInterval = duration
            toView.frame = container.bounds
            container.addSubview(toView)
            
            UIView.animate(withDuration: 0) {
                toView.alpha = 0.0
            }
            
            UIView.animate(withDuration: duration, animations: {
                toView.alpha = 1
            }) { (act) in
                transitionContext.completeTransition(true)
            }
        }else {
            let fromView = transitionContext.view(forKey:UITransitionContextViewKey.from)!
            let container = transitionContext.containerView
            container.addSubview(fromView)
            
            let duration = self.transitionDuration(using: transitionContext)
            
            UIView.animate(withDuration: duration, animations: {
                fromView.alpha = 0.0
            }) { (act) in
                transitionContext.completeTransition(true)
            }
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }

}
