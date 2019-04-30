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
    let array: [UIColor] = [.red, .green, .yellow, .blue, .orange, .purple, .red]
    
    weak var delegate: ToWatchDelegateProtocol?
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = array[indexPath.item]
        return cell
    }
    
    //    MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: AppStyle.itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: AppStyle.menuViewHeight + AppStyle.arrowViewHeight, left: 0.0, bottom: 0, right: 0.0)
    }
    
    // MARK: - UICollectionViewDelegate
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
        
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .clear
    }
    
    private func moveItemsFromScreen(forItem indexPath: IndexPath) {
        let items = collectionView.visibleCells.sorted { $0.frame.maxY < $1.frame.maxY }
        let lastItem = items.last!
        let lastItemIndexPath = collectionView.indexPath(for: lastItem)!
        
        for item in items {
            let itemIndexPath = collectionView.indexPath(for: item)!
            
            if itemIndexPath.item < indexPath.item {
                hideIfNeeded(item)
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
    
    func moveItemsBack() {
        let items = collectionView.visibleCells.sorted { $0.frame.maxY < $1.frame.maxY }
        for item in items {
            UIView.animate(withDuration: 0.6, animations: {
                item.transform = CGAffineTransform.identity
            }) { finished in
                //    first bring menubar back at the top
                //    then unhide item
                self.delegate?.didFinishMoveItemsBack()
                self.unHideIfNeeded(item)
            }
        }
    }
    
    private func hideIfNeeded(_ item: UICollectionViewCell) {
        let frameInView = self.view.convert(item.frame, from: self.collectionView)
        //      if item is fully under menubar
        if frameInView.minY < AppStyle.menuBarFullHeight && frameInView.maxY <= AppStyle.menuBarFullHeight {
            item.isHidden = true
        }
        //      if item is partly under menubar
        if frameInView.minY < AppStyle.menuBarFullHeight && frameInView.maxY > AppStyle.menuBarFullHeight {
            let maskLayer = CAShapeLayer()
            maskLayer.path = CGPath(rect: CGRect(x: 0,
                                                 y: AppStyle.menuBarFullHeight - frameInView.minY,
                                                 width: item.frame.width,
                                                 height: item.frame.height - (AppStyle.menuBarFullHeight - frameInView.minY)), transform: nil)
            item.layer.mask = maskLayer
        }
    }
    
    private func unHideIfNeeded(_ item: UICollectionViewCell) {
        if item.isHidden {
            item.isHidden = false
        }
        if item.layer.mask != nil {
            item.layer.mask = nil
        }
    }
    
}
