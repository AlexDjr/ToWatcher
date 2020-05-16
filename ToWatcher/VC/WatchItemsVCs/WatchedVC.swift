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
        
        collectionView!.register(WatchedItemCell.self, forCellWithReuseIdentifier: WatchItemCell.reuseIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WatchItemCell.reuseIdentifier, for: indexPath) as! WatchedItemCell
        cell.watchItem = watchItems[indexPath.item]
        cell.delegate = self
        return cell
    }
}
