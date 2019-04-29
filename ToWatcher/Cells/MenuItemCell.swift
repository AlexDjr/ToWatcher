//
//  MenuItemCell.swift
//  ToWatcher
//
//  Created by Alex Delin on 20/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

enum MenuItemState {
    case active
    case inactive
    case empty
}

class MenuItemCell: UICollectionViewCell {
    
    var itemState: MenuItemState {
        didSet {
            switch itemState {
            case .active:
                itemNameLabel.textColor = #colorLiteral(red: 0.2156862745, green: 0.2784313725, blue: 0.3137254902, alpha: 1)
            case .inactive:
                itemNameLabel.textColor = #colorLiteral(red: 0.7529411765, green: 0.7725490196, blue: 0.7843137255, alpha: 1)
                itemImageView.image = itemImageView.image?.withRenderingMode(.alwaysTemplate)
                itemImageView.tintColor = #colorLiteral(red: 0.7529411765, green: 0.7725490196, blue: 0.7843137255, alpha: 1)
            default:
                break
            }
        }
    }
    
    var itemImage: UIImage? {
        didSet {
            itemImageView.image = itemImage
        }
    }
    var itemName: String? {
        didSet {
            itemNameLabel.text = itemName
        }
    }
    
    private var itemNameLabel: UILabel = {
        let itemNameLabel = UILabel()
        itemNameLabel.font = UIFont(name: "Montserrat-Bold", size: 11)
        return itemNameLabel
    }()
    
    private var itemImageView: UIImageView = {
        let itemImageView = UIImageView(image: nil)
        return itemImageView
    }()
    
    override init(frame: CGRect) {
        self.itemState = .empty
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        stackView.addArrangedSubview(itemImageView)
        stackView.addArrangedSubview(itemNameLabel)
        
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}