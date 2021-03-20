//
//  MenuItem.swift
//  ToWatcher
//
//  Created by Alex Delin on 22/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class MenuItem: Equatable {
    var type: MenuItemType = .empty
    var image: UIImage?
    var name: String?
    
    convenience init(_ type: MenuItemType) {
        var name: String? = nil
        var image: UIImage? = nil
        
        switch type {
        case .toWatch:
            name = "ПОСМОТРЕТЬ"
            image = AppStyle.menuItemToWatchImage
        case .watched:
            name = "ПРОСМОТРЕНО"
            image = AppStyle.menuItemWatchedImage
        default:
            break
        }
        self.init(image: image, name: name)
        self.type = type
    }
    
    init(image: UIImage?, name: String?) {
        self.image = image
        self.name = name
    }
    
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        return lhs.name == rhs.name
    }
}

var menuItems: [MenuItem] = [MenuItem(.empty),
                             MenuItem(.toWatch),
                             MenuItem(.watched),
                             MenuItem(.empty)]

extension MenuItem {
    var counter: Int {
        let index = menuItems.firstIndex(of: self)
        
        switch index {
        case 1: return DBManager.shared.getWatchItems(.toWatch).count
        case 2: return DBManager.shared.getWatchItems(.watched).count
        default: break
        }
        
        return 0
    }
}
