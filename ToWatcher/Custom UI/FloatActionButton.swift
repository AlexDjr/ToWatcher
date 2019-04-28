//
//  BottomButton.swift
//  ToWatcher
//
//  Created by Alex Delin on 27/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class FloatActionButton: UIButton  {
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.cornerRadius = frame.height / 2
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        setImage(#imageLiteral(resourceName: "plus"), for: .highlighted)
    }
}
