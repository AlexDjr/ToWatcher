//
//  ToWatchController.swift
//  ToWatcher
//
//  Created by Alex Delin on 23/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class ToWatchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "Cell"
    let array: [UIColor] = [.red, .green, .yellow, .blue, .orange, .purple, .red, .green, .yellow, .blue, .orange, .purple]
    
//    let menuBarHeight = UIApplication.shared.statusBarFrame.height + 88 + 18
    
    weak var delegate: ToWatchDelegateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .clear
    }
    

    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Configure the cell
        cell.backgroundColor = array[indexPath.item]
        
        return cell
    }
    
    //    MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 88 + 18, left: 0.0, bottom: 0, right: 0.0)
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.bringSubviewToFront(collectionView)
//        parentController?.view.bringSubviewToFront(parentController!.containerView)
//        parentController?.view.bringSubviewToFront(parentController!.floatActionButton)
        delegate?.didSelectItem()
        //        collectionView.layer.zPosition = 3
        
        hideItemsForDetails(ofItemAt: indexPath)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            self.moveItemsToOriginal()
//        }
        
    }
    
    private func hideItemsForDetails(ofItemAt indexPath: IndexPath) {
        let items = collectionView.visibleCells.sorted { $0.frame.maxY < $1.frame.maxY }
        let lastItem = items.last!
        let lastItemIndexPath = collectionView.indexPath(for: lastItem)!
        
        for item in items {
            let itemIndexPath = collectionView.indexPath(for: item)!
            
            if itemIndexPath.item < indexPath.item {
                UIView.animate(withDuration: 0.6, delay: 0.1 * Double(itemIndexPath.item), options: .curveEaseInOut, animations: {
                    item.transform = CGAffineTransform.init(translationX: 0, y: -1000)
                }, completion: nil)
            }
            
            if itemIndexPath.item > indexPath.item {
                UIView.animate(withDuration: 0.6, delay: 0.1 * Double(lastItemIndexPath.item - itemIndexPath.item + 1), options: .curveEaseInOut, animations: {
                    item.transform = CGAffineTransform.init(translationX: 0, y: 1000)
                }, completion: nil)
            }
            
            if itemIndexPath.item == indexPath.item {
                UIView.animate(withDuration: 0.6, delay: 0.1 * Double(indexPath.item), options: .curveEaseInOut, animations: {
                    let frameInView = self.view.convert(item.frame, from: self.collectionView)
                    item.transform = CGAffineTransform.init(translationX: 0, y: -(frameInView.minY - AppStyle.topSafeArea))
                }, completion: nil)
            }
        }
    }
    
    func moveItemsToOriginal() {
        let items = collectionView.visibleCells.sorted { $0.frame.maxY < $1.frame.maxY }
        for item in items {
            UIView.animate(withDuration: 0.8, animations: {
                item.transform = CGAffineTransform.identity
            })
        }
    }
    
}
