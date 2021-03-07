//
//  UIStackView_ext.swift
//  ToWatcher
//
//  Created by Alex Delin on 08.03.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import UIKit

extension UIStackView {
    func set(axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment) -> UIStackView {
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        return self
    }
}
