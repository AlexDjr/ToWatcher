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


var toWatchItems: [WatchItem] = [WatchItem(image: #imageLiteral(resourceName: "6")), WatchItem(image: #imageLiteral(resourceName: "2")), WatchItem(image: #imageLiteral(resourceName: "7")), WatchItem(image: #imageLiteral(resourceName: "1")), WatchItem(image: #imageLiteral(resourceName: "3")), WatchItem(image: #imageLiteral(resourceName: "4")), WatchItem(image: #imageLiteral(resourceName: "5"))]
var watchedItems: [WatchItem] = [WatchItem(image: #imageLiteral(resourceName: "9")), WatchItem(image: #imageLiteral(resourceName: "10")), WatchItem(image: #imageLiteral(resourceName: "8")), WatchItem(image: #imageLiteral(resourceName: "11"))]
