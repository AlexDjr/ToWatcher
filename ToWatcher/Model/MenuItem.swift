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

extension MenuItem: Equatable {
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        return lhs.state == rhs.state && lhs.image == rhs.image && lhs.name == rhs.name
    }
}

var menuItems: [MenuItem] = [MenuItem(state: .empty, image: nil, name: nil),
                             MenuItem(state: .active, image: AppStyle.menuItemToWatchImage, name: "ПОСМОТРЕТЬ"),
                             MenuItem(state: .inactive, image: AppStyle.menuItemWatchedImage, name: "ПРОСМОТРЕНО"),
                             MenuItem(state: .empty, image: nil, name: nil)]


