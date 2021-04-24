//
//  WatchedVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 12/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class WatchedVC: WatchItemsVC {
    private let watchedItemCellReuseIdentifier = "watchedItemCell"
    
    override var watchType: WatchType {
        get {
            WatchType.watched
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
    
    override var screen: ScreenType { .watched }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.register(WatchedItemCell.self, forCellWithReuseIdentifier: watchedItemCellReuseIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: watchedItemCellReuseIdentifier, for: indexPath) as! WatchedItemCell
        cell.watchItem = watchItems[indexPath.item]
        cell.delegate = self
        return cell
    }
}
