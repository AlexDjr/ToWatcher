//
//  MenuItem.swift
//  ToWatcher
//
//  Created by Alex Delin on 22/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class MenuItem {
    var state: MenuItemState
    var image: UIImage?
    var name: String?
    
    init(state: MenuItemState, image: UIImage?, name: String?) {
        self.state = state
        self.image = image
        self.name = name
    }
}
 var menuItems: [MenuItem] = [MenuItem(state: .empty, image: nil, name: nil),
                              MenuItem(state: .active, image: #imageLiteral(resourceName: "menu-item-to-watch"), name: "ПОСМОТРЕТЬ"),
                              MenuItem(state: .inactive, image: #imageLiteral(resourceName: "menu-item-watched"), name: "ПРОСМОТРЕНО"),
                              MenuItem(state: .empty, image: nil, name: nil)]


