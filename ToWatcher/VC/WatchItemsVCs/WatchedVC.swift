//
//  WatchedVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 12/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class WatchedVC: WatchItemsVC {
    
    override var watchItems: [WatchItem] {
        didSet {
            watchedItems = watchItems
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watchItems = watchedItems
    }
}
