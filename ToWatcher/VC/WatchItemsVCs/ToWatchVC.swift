//
//  ToWatchVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 23/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class ToWatchVC: WatchItemsVC {
    
    override var watchItems: [WatchItem] {
        didSet {
            toWatchItems = watchItems
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watchItems = toWatchItems
    }
}
