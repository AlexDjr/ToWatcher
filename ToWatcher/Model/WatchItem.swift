//
//  WatchItem.swift
//  ToWatcher
//
//  Created by Alex Delin on 10.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

class WatchItem: Equatable {
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    static func == (lhs: WatchItem, rhs: WatchItem) -> Bool {
        return lhs.image == rhs.image
    }
}
