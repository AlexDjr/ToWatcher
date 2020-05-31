//
//  UIView_ext.swift
//  ToWatcher
//
//  Created by Alex Delin on 30/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow(_ corners: UIRectCorner, radius: CGFloat) {
        backgroundColor = UIColor.clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: -3, height: 4)
        layer.shadowOpacity = 0.15
        layer.shadowRadius = self.frame.height * AppStyle.itemShadowRadiusCoeff
        
        // For better perfomance
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: corners,
                                        cornerRadii: CGSize(width: radius, height: radius)).cgPath
        // TODO: Rasterization shouldn't be used if view is going to be transformed (scaled up) at any point (SearchItemCell)
        // layer.shouldRasterize = true
        // layer.rasterizationScale = UIScreen.main.scale
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: layer.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
        
        layer.masksToBounds = true
    }
}
