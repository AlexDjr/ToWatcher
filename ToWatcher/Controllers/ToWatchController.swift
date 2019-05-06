//
//  ToWatchController.swift
//  ToWatcher
//
//  Created by Alex Delin on 23/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class ToWatchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let array: [UIImage] = [#imageLiteral(resourceName: "6"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "5")]
    
    weak var delegate: ToWatchDelegateProtocol?
    
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WatchItemCell.reuseIdentifier, for: indexPath) as! WatchItemCell
        
        cell.itemImage = array[indexPath.item]
        
        return cell
    }
    
    //    MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: AppStyle.itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: AppStyle.menuViewHeight + AppStyle.arrowViewHeight, left: 0.0, bottom: 0, right: 0.0)
    }
    
    //    MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.bringSubviewToFront(collectionView)
        delegate?.didSelectItem()
        moveItemsFromScreen(forItem: indexPath)
    }
    
    //    MARK: - Methods
    private func setupCollectionView() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = round(AppStyle.itemHeight / 20)
        collectionView.collectionViewLayout = layout
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView!.register(WatchItemCell.self, forCellWithReuseIdentifier: WatchItemCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
    }
    
    private func moveItemsFromScreen(forItem indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        let items = collectionView.visibleCells.sorted { $0.frame.maxY < $1.frame.maxY }
        let firstItemIndexPath = collectionView.indexPath(for: items.first!)!
        let lastItemIndexPath = collectionView.indexPath(for: items.last!)!
        
        for item in items {
            let itemIndexPath = collectionView.indexPath(for: item)!
            
            //    items OVER selected item
            if itemIndexPath.item < indexPath.item {
                hideIfNeeded(item)
                UIView.animate(withDuration: 0.5,
                               delay: 0.1 * Double(itemIndexPath.item - firstItemIndexPath.item + 1),
                               options: .curveEaseInOut,
                               animations: {
                                   item.transform = CGAffineTransform.init(translationX: 0, y: -1000)
                               },
                               completion: nil)
            }
            
            //    items UNDER selected item
            if itemIndexPath.item > indexPath.item {
                UIView.animate(withDuration: 0.5,
                               delay: 0.1 * Double(lastItemIndexPath.item - itemIndexPath.item + 1),
                               options: .curveEaseInOut,
                               animations: {
                                   item.transform = CGAffineTransform.init(translationX: 0, y: 1000)
                               },
                               completion: nil)
            }
            
            //    SELECTED item
            if itemIndexPath.item == indexPath.item {
                UIView.animate(withDuration: 0.5,
                               delay: 0.1 * Double(max(lastItemIndexPath.item - indexPath.item, indexPath.item - firstItemIndexPath.item) + 1),
                               options: .curveEaseInOut,
                               animations: {
                                   let frameInView = self.view.convert(item.frame, from: self.collectionView)
                                   item.transform = CGAffineTransform.init(translationX: 0, y: -(frameInView.minY - AppStyle.topSafeArea))
                               },
                               completion: nil)
            }
        }
    }
    
    func moveItemsBack() {
        guard let indexPath = selectedIndexPath else { return }
        
        let items = collectionView.visibleCells.sorted { $0.frame.maxY < $1.frame.maxY }
        let firstItemIndexPath = collectionView.indexPath(for: items.first!)!

        for item in items {
            let itemIndexPath = collectionView.indexPath(for: item)!
            
            //    items OVER selected item
            if itemIndexPath.item < indexPath.item {
                UIView.animate(withDuration: 0.5,
                               delay: 0.1 * Double(indexPath.item - itemIndexPath.item),
                               options: .curveEaseInOut,
                               animations: {
                                item.transform = CGAffineTransform.identity
                               }) { finished in
                                    //    bringing menubar back when top item moved back
                                    if itemIndexPath == firstItemIndexPath {
                                        self.delegate?.didFinishMoveItemsBack()
                                    }
                                    //    only items over selected item could be hidden
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        self.unHideIfNeeded(item)
                                  }
                }
            }
            
            //    items UNDER selected item
            if itemIndexPath.item > indexPath.item {
                UIView.animate(withDuration: 0.5,
                               delay: 0.1 * Double(itemIndexPath.item - indexPath.item),
                               options: .curveEaseInOut,
                               animations: {
                                item.transform = CGAffineTransform.identity
                               },
                               completion: nil)
            }
            
            //    SELECTED item
            if itemIndexPath.item == indexPath.item {
                UIView.animate(withDuration: 0.5, animations: {
                    item.transform = CGAffineTransform.identity
                }) { finished in
                    //    bringing menubar back when top item moved back
                    if itemIndexPath == firstItemIndexPath {
                        self.delegate?.didFinishMoveItemsBack()
                    }
                    //    only items over selected item could be hidden
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.unHideIfNeeded(item)
                    }
                }
            }
        }
    }
    
    private func hideIfNeeded(_ item: UICollectionViewCell) {
        let frameInView = self.view.convert(item.frame, from: self.collectionView)
        //      if item is fully under menubar
        if frameInView.minY < AppStyle.menuBarFullHeight && frameInView.maxY <= AppStyle.menuBarFullHeight {
            item.isHidden = true
        }
    }
    
    private func unHideIfNeeded(_ item: UICollectionViewCell) {
        if item.isHidden {
            item.isHidden = false
        }
    }
    
}
