//
//  ScoreView.swift
//  ToWatcher
//
//  Created by Alex Delin on 15.02.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import UIKit

class ScoreView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = AppStyle.mainBGColor
        self.layer.cornerRadius = 28
        self.layer.borderWidth = 3.0
        self.layer.borderColor = AppStyle.menuItemWatchedCounterColor.cgColor
        
        let label = UILabel()
        label.font = UIFont(name: AppStyle.appFontNameBold, size: 18.0)
        label.textColor = AppStyle.menuItemActiveTextColor
        label.text = "7.5"
        
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
