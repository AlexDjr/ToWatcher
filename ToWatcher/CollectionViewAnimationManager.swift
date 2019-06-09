//
//  CollectionViewAnimationManager.swift
//  ToWatcher
//
//  Created by Alex Delin on 09/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class CollectionViewAnimationManager {
    static let shared = CollectionViewAnimationManager()
    
    var fromScreenFinishedCallback: (() -> ())?
    var backToScreenFinishedCallback: (() -> ())?
    
    enum AnimationType {
        case fromScreen
        case backToScreen
    }
    
    enum AnimatedItemType {
        case over
        case under
        case selected
    }
    
    typealias AnimationParams = (delay: TimeInterval, transform: CGAffineTransform?, completion: ((Bool) -> ())?)
    
    var collectionView: UICollectionView?
    var selectedIndexPath: IndexPath?
    var firstItemIndexPath: IndexPath?
    var lastItemIndexPath: IndexPath?
    
    
    func animateItems(withAnimationType animationType: AnimationType) {
        guard let collectionView = collectionView, let selectedIndexPath = selectedIndexPath else { return }
        
        let items = collectionView.visibleCells.sorted { $0.frame.maxY < $1.frame.maxY }
        firstItemIndexPath = collectionView.indexPath(for: items.first!)!
        lastItemIndexPath = collectionView.indexPath(for: items.last!)!
        
        guard let _ = firstItemIndexPath, let _ = lastItemIndexPath else { return }
        
        for item in items {
            let itemIndexPath = collectionView.indexPath(for: item)!
            
            if itemIndexPath.item < selectedIndexPath.item {
                animate(item, withAnimationType: animationType, andItemType: .over)
            } else if itemIndexPath.item > selectedIndexPath.item {
                animate(item, withAnimationType: animationType, andItemType: .under)
            } else if itemIndexPath.item == selectedIndexPath.item {
                animate(item, withAnimationType: animationType, andItemType: .selected)
            }
        }
    }
    
    private func animate(_ item: UICollectionViewCell, withAnimationType animationType: AnimationType, andItemType animatedItemType: AnimatedItemType) {
        let delay = setupAnimationParams(for: item, with: animationType, and: animatedItemType)!.delay
        let transform = setupAnimationParams(for: item, with: animationType, and: animatedItemType)!.transform
        let completion = setupAnimationParams(for: item, with: animationType, and: animatedItemType)!.completion
        
        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       options: .curveEaseInOut,
                       animations: { item.transform = transform! },
                       completion: completion)
    }
    
    private func setupAnimationParams(for item: UICollectionViewCell, with animationType: AnimationType, and animatedItemType: AnimatedItemType) -> (AnimationParams?) {
        guard let collectionView = collectionView else { return nil }
        
        let itemIndexPath = collectionView.indexPath(for: item)!
        var delay: TimeInterval = 0.0
        var transform: CGAffineTransform? = nil
        var completion: ((Bool) -> ())? = nil
        
        if animationType == .fromScreen {
            switch animatedItemType {
            case .over:
                hideIfNeeded(item)
                delay = 0.1 * Double(itemIndexPath.item - firstItemIndexPath!.item + 1)
                transform = CGAffineTransform.init(translationX: 0, y: -1000)
                completion = nil
            case .under:
                delay = 0.1 * Double(lastItemIndexPath!.item - itemIndexPath.item + 1)
                transform = CGAffineTransform.init(translationX: 0, y: 1000)
                completion = nil
            case .selected:
                delay = 0.1 * Double(max(lastItemIndexPath!.item - selectedIndexPath!.item, selectedIndexPath!.item - firstItemIndexPath!.item) + 1)
                
                let frameInView = collectionView.superview!.convert(item.frame, from: self.collectionView)
                transform = CGAffineTransform.init(translationX: 0, y: -(frameInView.minY - AppStyle.topSafeArea))
                completion = { finished in
                    if finished {
                        self.runActionsAfterAnimation(for:item, with: animationType, and: animatedItemType)
                    }
                }
            }
        } else if animationType == .backToScreen {
            switch animatedItemType {
            case .over:
                delay = 0.1 * Double(selectedIndexPath!.item - itemIndexPath.item)
                transform = CGAffineTransform.identity
                completion = { finished in
                    if finished {
                        self.runActionsAfterAnimation(for:item, with: animationType, and: animatedItemType)
                    }
                }
            case .under:
                delay = 0.1 * Double(itemIndexPath.item - selectedIndexPath!.item)
                transform = CGAffineTransform.identity
                completion = nil
            case .selected:
                delay = 0.0
                transform = CGAffineTransform.identity
                completion = { finished in
                    if finished {
                        self.runActionsAfterAnimation(for:item, with: animationType, and: animatedItemType)
                    }
                }
            }
        }
        return (delay, transform, completion)
    }
    
    private func runActionsAfterAnimation(for item: UICollectionViewCell, with animationType: AnimationType, and animatedItemType: AnimatedItemType) {
        guard let collectionView = collectionView else { return }
        
        if animationType == .fromScreen {
            if animatedItemType == .selected {
                fromScreenFinishedCallback?()
            }
        } else if animationType == .backToScreen {
            let itemIndexPath = collectionView.indexPath(for: item)!
            let isTopItemMovedBack = itemIndexPath == self.firstItemIndexPath!
            
            if isTopItemMovedBack {
                backToScreenFinishedCallback?()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.unHideIfNeeded(item)
            }
        }
    }
    
    private func hideIfNeeded(_ item: UICollectionViewCell) {
        guard let collectionView = collectionView else { return }
        
        let frameInView = collectionView.superview!.convert(item.frame, from: self.collectionView)
        let isItemFullyUnderMenubar = frameInView.minY < AppStyle.menuBarFullHeight && frameInView.maxY <= AppStyle.menuBarFullHeight;
        
        if isItemFullyUnderMenubar {
            item.isHidden = true
        }
    }
    
    private func unHideIfNeeded(_ item: UICollectionViewCell) {
        if item.isHidden {
            item.isHidden = false
        }
    }
}
