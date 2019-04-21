//
//  MenuCell.swift
//  ToWatcher
//
//  Created by Alex Delin on 20/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.layer.borderColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        self.layer.borderWidth = 1.0
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        let itemIconView = UIImageView(image: #imageLiteral(resourceName: "menu-item-to-watch"))
        
        let itemNameLabel = UILabel()
        itemNameLabel.text = "ПОСМОТРЕТЬ"
        itemNameLabel.font = UIFont(name: "Montserrat-Bold", size: 11)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center

        stackView.addArrangedSubview(itemIconView)
        stackView.addArrangedSubview(itemNameLabel)

        self.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}
