//
//  UITextField+bottomBorder.swift
//  ToWatcher
//
//  Created by Alex Delin on 08/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

extension UITextField {
    func addBottomBorder(){
        let bottomBorder = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = self.tintColor
        
        addSubview(bottomBorder)
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
