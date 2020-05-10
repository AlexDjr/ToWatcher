//
//  WatchedVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 12/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class WatchedVC: WatchItemsVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watchItems = [WatchItem(image: #imageLiteral(resourceName: "9")), WatchItem(image: #imageLiteral(resourceName: "10")), WatchItem(image: #imageLiteral(resourceName: "8")), WatchItem(image: #imageLiteral(resourceName: "11"))]
    }
}
