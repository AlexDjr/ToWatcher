//
//  ToWatchVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 23/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class ToWatchVC: WatchItemsVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watchItems = [WatchItem(image: #imageLiteral(resourceName: "6")), WatchItem(image: #imageLiteral(resourceName: "2")), WatchItem(image: #imageLiteral(resourceName: "7")), WatchItem(image: #imageLiteral(resourceName: "1")), WatchItem(image: #imageLiteral(resourceName: "3")), WatchItem(image: #imageLiteral(resourceName: "4")), WatchItem(image: #imageLiteral(resourceName: "5"))]
    }
}
