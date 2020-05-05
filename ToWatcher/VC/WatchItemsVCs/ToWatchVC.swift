//
//  ToWatchVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 23/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class ToWatchVC: WatchItemsVC, UICollectionViewDataSource, WatchItemEditProtocol {

    var array: [UIImage] = [#imageLiteral(resourceName: "6"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "5")]
    
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
        cell.setImage(array[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    // MARK: - WatchItemsVC Methods
    override func setupCollectionView() {
        super.setupCollectionView()
        collectionView.dataSource = self
    }
    
    // MARK: - WatchItemEditProtocol
    func didRemoveItem(_ cell: UICollectionViewCell, withType type: WatchItemEditState) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        deleteCell(at: indexPath)
    }
    
    // MARK: - Private methods
    private func deleteCell(at indexPath: IndexPath) {
        moveItemsEditMode()
        array.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
}
