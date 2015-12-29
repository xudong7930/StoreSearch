//
//  DimmingPresentationController.swift
//  StoreSearch20151227
//
//  Created by xudong7930 on 12/28/15.
//  Copyright © 2015 xudong7930. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
    
    // MARK: - VAR AND LET
    lazy var dimmingView = GradientView(frame: CGRect.zero)
    
    // MARK: - VIEW AND INIT
    
    
    override func shouldRemovePresentersView() -> Bool {
        return false
    }
    
    
    override func presentationTransitionWillBegin() {
        
        dimmingView.frame = containerView!.bounds
        
        containerView!.insertSubview(dimmingView, atIndex: 0)
        
        dimmingView.alpha = 0
        
        if let transitionCoordinator = presentedViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({
                    _ in
                self.dimmingView.alpha = 1
                }, completion: nil)
        }
        
    }
    
    
    override func dismissalTransitionWillBegin() {
        if let transitionCoordinator = presentedViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({
                _ in
                self.dimmingView.alpha = 0
                }, completion: nil)
        }
    }
}

