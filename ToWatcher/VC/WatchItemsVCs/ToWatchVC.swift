//
//  ToWatchVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 23/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class ToWatchVC: WatchItemsVC {
    
    override var watchType: WatchType {
        get {
            WatchType.toWatch
        }
        set {
            super.watchType = newValue
        }
    }
    
    override var watchItems: [WatchItem] {
        get {
            DBManager.shared.getWatchItems(watchType)
        }
        set {
            super.watchItems = newValue
        }
    }
    
    override var screen: ScreenType { .toWatch }
}
