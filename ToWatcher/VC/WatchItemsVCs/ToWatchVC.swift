//
//  ToWatchVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 23/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class ToWatchVC: WatchItemsVC, UICollectionViewDataSource {

    let array: [UIImage] = [#imageLiteral(resourceName: "6"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "5")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WatchItemCell.reuseIdentifier, for: indexPath) as! WatchItemCell
        cell.itemImage = array[indexPath.item]
        return cell
    }
    
    // MARK: - Methods
    override func setupCollectionView() {
        super.setupCollectionView()
        collectionView.dataSource = self
    }
    
}
