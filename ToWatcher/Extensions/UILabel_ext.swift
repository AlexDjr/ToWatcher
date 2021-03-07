//
//  UILabel_ext.swift
//  ToWatcher
//
//  Created by Alex Delin on 07.02.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import UIKit

extension UILabel {
    func addShadow(radius: CGFloat) -> UILabel {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 0.35
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.masksToBounds = false
        return self
    }
    
    func set(font: UIFont, color: UIColor, numberOfLines: Int, minimumScale: CGFloat = 1.0, alignment: NSTextAlignment = .left) -> UILabel {
        self.numberOfLines = numberOfLines
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = minimumScale
        
        return self
    }
    
}
