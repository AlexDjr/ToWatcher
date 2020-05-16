//
//  MenuItemCell.swift
//  ToWatcher
//
//  Created by Alex Delin on 20/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class MenuItemCell: UICollectionViewCell {
    static let reuseIdentifierEmpty = "menuItemCellEmpty"
    static let reuseIdentifierToWatch = "menuItemCellToWatch"
    static let reuseIdentifierWatched = "menuItemCellWatched"
    
    var menuItem: MenuItem? {
        didSet {
            setupCell()
        }
    }
    
    var itemState: MenuItemState = .inactive {
        didSet {
            menuItmeView.setupState(itemState)
        }
    }
    
    private lazy var menuItmeView = MenuItemView()
    
    override var isSelected: Bool {
        didSet {
            self.itemState = isSelected ? .active : .inactive
        }
    }
    
    func setupCell() {
        menuItmeView.menuItem = menuItem
        
        contentView.addSubview(menuItmeView)
        menuItmeView.translatesAutoresizingMaskIntoConstraints = false
        menuItmeView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        menuItmeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        menuItmeView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        menuItmeView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
}
