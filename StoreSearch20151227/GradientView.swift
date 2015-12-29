//
//  GradientView.swift
//  StoreSearch20151227
//
//  Created by xudong7930 on 12/28/15.
//  Copyright © 2015 xudong7930. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    // MARK: - VIEW AND INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = UIColor.clearColor()
    }
    
    
    override func drawRect(rect: CGRect) {
        
        let components: [CGFloat] = [0, 0, 0, 0.3, 0, 0, 0, 0.7]
        let locations: [CGFloat] = [0, 1]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2)
        
        let x = CGRectGetMidX(bounds)
        let y = CGRectGetMidY(bounds)
        
        let point = CGPoint(x: x, y: y)
        let radius = max(x, y)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawRadialGradient(context, gradient, point, 0, point, radius, .DrawsAfterEndLocation)
        
    }
    
    
    
    
}
