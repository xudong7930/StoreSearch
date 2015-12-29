//
//  BounceAnimationController.swift
//  StoreSearch20151227
//
//  Created by xudong7930 on 12/28/15.
//  Copyright © 2015 xudong7930. All rights reserved.
//

import UIKit

class BounceAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) {
            
            if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
                toView.frame = transitionContext.finalFrameForViewController(toViewController)
                
                let containerView = transitionContext.containerView()
                containerView?.addSubview(toView)
                
                
                toView.transform = CGAffineTransformMakeScale(0.7, 0.7)
                
                UIView.animateKeyframesWithDuration(
                    transitionDuration(transitionContext),
                    delay: 0.0,
                    options: .CalculationModeCubic,
                    animations: {
                        UIView.addKeyframeWithRelativeStartTime(0.0,
                            relativeDuration: 0.334,
                            animations: {
                                toView.transform = CGAffineTransformMakeScale(1.2, 1.2)
                        })
                        
                        UIView.addKeyframeWithRelativeStartTime(0.334, relativeDuration: 0.333, animations: {
                            toView.transform = CGAffineTransformMakeScale(0.9, 0.9)
                        })
                        
                        UIView.addKeyframeWithRelativeStartTime(0.666, relativeDuration: 0.333, animations: {
                            toView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                        })
                    },
                    completion: {
                        (finished) in
                        transitionContext.completeTransition(finished)
                })
            }
            
        }
    }
}
