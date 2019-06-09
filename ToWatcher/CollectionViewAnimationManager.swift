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
        case watchItems
        case menuItems
    }
    
    enum AnimationDirection {
        case fromScreen
        case backToScreen
    }
    
    enum AnimatedItemLocation {
        case before
        case after
        case selected
    }
    
    var collectionView: UICollectionView?
    var selectedIndexPath: IndexPath?
    var firstItemIndexPath: IndexPath?
    var lastItemIndexPath: IndexPath?
    
    
    func animateItems(withType type: AnimationType, andDirection direction: AnimationDirection) {
        guard let collectionView = collectionView, let selectedIndexPath = selectedIndexPath else { return }
        
        let items = collectionView.visibleCells.sorted { collectionView.indexPath(for: $0)!.item < collectionView.indexPath(for: $1)!.item }
        firstItemIndexPath = collectionView.indexPath(for: items.first!)!
        lastItemIndexPath = collectionView.indexPath(for: items.last!)!
        
        guard let _ = firstItemIndexPath, let _ = lastItemIndexPath else { return }
        
        for item in items {
            let itemIndexPath = collectionView.indexPath(for: item)!
            
            if itemIndexPath.item < selectedIndexPath.item {
                animate(item, withType: type, andDirection: direction, andLocation: .before)
            } else if itemIndexPath.item > selectedIndexPath.item {
                animate(item, withType: type, andDirection: direction, andLocation: .after)
            } else if itemIndexPath.item == selectedIndexPath.item {
                animate(item, withType: type, andDirection: direction, andLocation: .selected)
            }
        }
    }
    
    private func animate(_ item: UICollectionViewCell,
                         withType type: AnimationType,
                         andDirection direction: AnimationDirection,
                         andLocation location: AnimatedItemLocation) {
        let isItemUnderMenuBarWhenFromScreen = type == .watchItems && location == .before && direction == .fromScreen
        if isItemUnderMenuBarWhenFromScreen {
            hideIfNeeded(item)
        }
            
        let delay = setupAnimationParamDelay(for: item, withType: type, andDirection: direction, andLocation: location)
        let transform = setupAnimationParamTransform(for: item, withType: type, andDirection: direction, andLocation: location)
        let completion = setupAnimationParamCompletion(for: item, withType: type, andDirection: direction, andLocation: location)
        
        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       options: .curveEaseInOut,
                       animations: { item.transform = transform! },
                       completion: completion)
    }
    
    private func setupAnimationParamDelay(for item: UICollectionViewCell,
                                          withType type: AnimationType,
                                          andDirection direction: AnimationDirection,
                                          andLocation location: AnimatedItemLocation) -> TimeInterval {
        guard let collectionView = collectionView else { return 0.0 }
        
        var delay: TimeInterval = 0.0
        let itemIndexPath = collectionView.indexPath(for: item)!
        
        if type == .watchItems {
            switch direction {
            case .fromScreen:
                switch location {
                case .before:   delay = 0.1 * Double(itemIndexPath.item - firstItemIndexPath!.item + 1)
                case .after:    delay = 0.1 * Double(lastItemIndexPath!.item - itemIndexPath.item + 1)
                case .selected: delay = 0.1 * Double(max(lastItemIndexPath!.item - selectedIndexPath!.item, selectedIndexPath!.item - firstItemIndexPath!.item) + 1)
                }
            case .backToScreen:
                switch location {
                case .before:   delay = 0.1 * Double(selectedIndexPath!.item - itemIndexPath.item)
                case .after:    delay = 0.1 * Double(itemIndexPath.item - selectedIndexPath!.item)
                case .selected: delay = 0.0
                }
            }
//            else if type == .menuItems {
//                switch direction {
//                case .fromScreen:
//                    switch location {
//                    case .before:
//                    case .after:
//                    case .selected:
//                    }
//                case .backToScreen:
//                    switch location {
//                    case .before:
//                    case .after:
//                    case .selected:
//                    }
//                }
//            }
        }
        
        return delay
    }
    
    private func setupAnimationParamTransform(for item: UICollectionViewCell,
                                              withType type: AnimationType,
                                              andDirection direction: AnimationDirection,
                                              andLocation location: AnimatedItemLocation) -> CGAffineTransform? {
        guard let collectionView = collectionView else { return nil }
        
        var transform: CGAffineTransform? = nil
        
        if type == .watchItems {
            switch direction {
            case .fromScreen:
                switch location {
                case .before:
                    transform = CGAffineTransform.init(translationX: 0, y: -1000)
                case .after:
                    transform = CGAffineTransform.init(translationX: 0, y: 1000)
                case .selected:
                    let frameInView = collectionView.superview!.convert(item.frame, from: self.collectionView)
                    transform = CGAffineTransform.init(translationX: 0, y: -(frameInView.minY - AppStyle.topSafeArea))
                }
            case .backToScreen:
                switch location {
                case .before:
                    transform = CGAffineTransform.identity
                case .after:
                    transform = CGAffineTransform.identity
                case .selected:
                    transform = CGAffineTransform.identity
                }
            }
            //            else if type == .menuItems {
            //                switch direction {
            //                case .fromScreen:
            //                    switch location {
            //                    case .before:
            //                    case .after:
            //                    case .selected:
            //                    }
            //                case .backToScreen:
            //                    switch location {
            //                    case .before:
            //                    case .after:
            //                    case .selected:
            //                    }
            //                }
            //            }
        }
        
        return transform
    }
    
    private func setupAnimationParamCompletion(for item: UICollectionViewCell,
                                               withType type: AnimationType,
                                               andDirection direction: AnimationDirection,
                                               andLocation location: AnimatedItemLocation) -> ((Bool) -> ())? {
        var completion: ((Bool) -> ())?  = nil
        
        if type == .watchItems {
            switch direction {
            case .fromScreen:
                switch location {
                case .before:
                    completion = nil
                case .after:
                    completion = nil
                case .selected:
                    completion = { finished in
                        if finished {
                            self.runActionsAfterAnimation(for: item, withType: type, andDirection: direction, andLocation: location)
                        }
                    }
                }
            case .backToScreen:
                switch location {
                case .before:
                    completion = { finished in
                        if finished {
                            self.runActionsAfterAnimation(for: item, withType: type, andDirection: direction, andLocation: location)
                        }
                    }
                case .after:
                    completion = nil
                case .selected:
                    completion = { finished in
                        if finished {
                            self.runActionsAfterAnimation(for: item, withType: type, andDirection: direction, andLocation: location)
                        }
                    }
                }
            }
            //            else if type == .menuItems {
            //                switch direction {
            //                case .fromScreen:
            //                    switch location {
            //                    case .before:
            //                    case .after:
            //                    case .selected:
            //                    }
            //                case .backToScreen:
            //                    switch location {
            //                    case .before:
            //                    case .after:
            //                    case .selected:
            //                    }
            //                }
            //            }
        }
        
        return completion
    }
    
    private func runActionsAfterAnimation(for item: UICollectionViewCell,
                                          withType type: AnimationType,
                                          andDirection direction: AnimationDirection,
                                          andLocation location: AnimatedItemLocation) {
        guard let collectionView = collectionView else { return }
        
        if direction == .fromScreen {
            if location == .selected {
                fromScreenFinishedCallback?()
            }
        } else if direction == .backToScreen {
            let itemIndexPath = collectionView.indexPath(for: item)!
            let isFirstItemMovedBack = itemIndexPath == self.firstItemIndexPath!
            
            if isFirstItemMovedBack {
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
