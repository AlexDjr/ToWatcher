//
//  MenuItem.swift
//  ToWatcher
//
//  Created by Alex Delin on 22/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class MenuItem {
    var image: UIImage?
    var name: String?
    
    init(image: UIImage?, name: String?) {
        self.image = image
        self.name = name
    }
}

var menuItems: [MenuItem] = [MenuItem(image: nil, name: nil),
                             MenuItem(image: AppStyle.menuItemToWatchImage, name: "ПОСМОТРЕТЬ"),
                             MenuItem(image: AppStyle.menuItemWatchedImage, name: "ПРОСМОТРЕНО"),
                             MenuItem(image: nil, name: nil)]


