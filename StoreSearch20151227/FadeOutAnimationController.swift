//
//  FadeOutAnimationController.swift
//  StoreSearch20151227
//
//  Created by xudong7930 on 12/29/15.
//  Copyright © 2015 xudong7930. All rights reserved.
//

import UIKit

class FadeOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) {
            
            let duration = transitionDuration(transitionContext)
            
            UIView.animateWithDuration(duration,
                animations: {
                    fromView.alpha = 0
                },
                completion: {
                    (finished) in
                    transitionContext.completeTransition(true)
            })
        }
    }
}
