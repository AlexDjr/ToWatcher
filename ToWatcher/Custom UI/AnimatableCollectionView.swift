//
//  AnimatableCollectionView.swift
//  ToWatcher
//
//  Created by Alex Delin on 10/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class AnimatableCollectionView: UICollectionView {
    var fromScreenFinishedCallback: (() -> ())?
    var backToScreenFinishedCallback: (() -> ())?
    
    enum AnimationType {
        case itemSelected
        case allItems
    }
    
    enum AnimationDirection {
        case fromScreen
        case backToScreen
    }
    
    private enum AnimatedItemLocation {
        case before
        case after
        case selected
    }
    
    var selectedIndexPath: IndexPath?
    private var firstItemIndexPath: IndexPath?
    private var lastItemIndexPath: IndexPath?
    private var itemsOnScreen: [UICollectionViewCell]!
    
    func animateItems(withType type: AnimationType, andDirection direction: AnimationDirection) {
        setupItemsOnScreen()
        setupIndexPaths()
        
        guard let selectedIndexPath = selectedIndexPath, let _ = firstItemIndexPath, let _ = lastItemIndexPath else { return }
        
        for item in itemsOnScreen {
            let itemIndexPath = self.indexPath(for: item)!
            
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
        let isNeedToCheckIfItemUnderMenuBar = location != .after && direction == .fromScreen
        if isNeedToCheckIfItemUnderMenuBar {
            hideIfNeeded(item)
        }
        
        let delay = setupAnimationParamDelay(for: item, withType: type, andDirection: direction, andLocation: location)
        let transform = setupAnimationParamTransform(for: item, withType: type, andDirection: direction, andLocation: location)
        let completion = setupAnimationParamCompletion(for: item, withType: type, andDirection: direction, andLocation: location)
        
        UIView.animate(withDuration: 0.4,
                       delay: delay,
                       options: .curveEaseInOut,
                       animations: { item.transform = transform! },
                       completion: completion)
    }
    
    private func setupAnimationParamDelay(for item: UICollectionViewCell,
                                          withType type: AnimationType,
                                          andDirection direction: AnimationDirection,
                                          andLocation location: AnimatedItemLocation) -> TimeInterval {
        
        var delay: TimeInterval = 0.0
        let itemIndexPath = self.indexPath(for: item)!
        
        if type == .itemSelected {
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
            
        } else if type == .allItems {
            switch direction {
            case .fromScreen:
                switch location {
                case .before:   delay = 0.0
                case .after:    delay = 0.1 * Double(lastItemIndexPath!.item - itemIndexPath.item + 1)
                case .selected: delay = 0.1 * Double(lastItemIndexPath!.item - selectedIndexPath!.item + 1)
                }
            case .backToScreen:
                switch location {
                case .before:   delay = 0.0
                case .after:    delay = 0.1 * Double(itemIndexPath.item - selectedIndexPath!.item)
                case .selected: delay = 0.0
                }
            }
        }
        
        return delay
    }
    
    private func setupAnimationParamTransform(for item: UICollectionViewCell,
                                              withType type: AnimationType,
                                              andDirection direction: AnimationDirection,
                                              andLocation location: AnimatedItemLocation) -> CGAffineTransform? {
        var transform: CGAffineTransform? = nil
        
        if type == .itemSelected {
            switch direction {
            case .fromScreen:
                switch location {
                case .before:
                    transform = CGAffineTransform(translationX: 0, y: -1000)
                case .after:
                    transform = CGAffineTransform(translationX: 0, y: 1000)
                case .selected:
                    let frameInView = self.superview!.convert(item.frame, from: self)
                    transform = CGAffineTransform(translationX: 0, y: -(frameInView.minY - AppStyle.topSafeArea))
                }
            case .backToScreen:
                transform = CGAffineTransform.identity
            }
            
        } else if type == .allItems {
            switch direction {
            case .fromScreen:
                transform = CGAffineTransform(translationX: 0, y: 1000)
            case .backToScreen:
                transform = CGAffineTransform.identity
            }
        }
        
        return transform
    }
    
    private func setupAnimationParamCompletion(for item: UICollectionViewCell,
                                               withType type: AnimationType,
                                               andDirection direction: AnimationDirection,
                                               andLocation location: AnimatedItemLocation) -> ((Bool) -> ())? {
        var completion: ((Bool) -> ())?  = nil
        
        if type == .itemSelected {
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
        } else if type == .allItems {
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
            }
        }
        
        return completion
    }
    
    private func runActionsAfterAnimation(for item: UICollectionViewCell,
                                          withType type: AnimationType,
                                          andDirection direction: AnimationDirection,
                                          andLocation location: AnimatedItemLocation) {
        if direction == .fromScreen {
            if location == .selected {
                fromScreenFinishedCallback?()
            }
        } else if direction == .backToScreen {
            let itemIndexPath = self.indexPath(for: item)!
            let isFirstItemMovedBack = itemIndexPath == self.firstItemIndexPath!
            
            if isFirstItemMovedBack {
                backToScreenFinishedCallback?()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.unHideIfNeeded(item)
            }
            selectedIndexPath = nil
        }
    }
    
    private func hideIfNeeded(_ item: UICollectionViewCell) {
        let frameInView = self.superview!.convert(item.frame, from: self)
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
    
    private func setupItemsOnScreen() {
        itemsOnScreen = self.visibleCells.sorted { self.indexPath(for: $0)!.item < self.indexPath(for: $1)!.item }
    }
    
    private func setupIndexPaths() {
        firstItemIndexPath = self.indexPath(for: itemsOnScreen.first!)!
        lastItemIndexPath = self.indexPath(for: itemsOnScreen.last!)!
        
        if selectedIndexPath == nil {
            selectedIndexPath = firstItemIndexPath
        }
    }
    
}
