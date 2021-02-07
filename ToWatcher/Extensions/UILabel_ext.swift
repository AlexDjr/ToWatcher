//
//  UILabel_ext.swift
//  ToWatcher
//
//  Created by Alex Delin on 07.02.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import UIKit

extension UILabel {
    func addShadow(radius: CGFloat) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 0.35
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.masksToBounds = false
    }
}
