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
        case watchItemSelected
        case searchItemSelected
        case allItems
        case editMode
    }
    
    enum AnimationDirection {
        case fromScreen
        case backToScreen
        case backToScreenAfterAddItem
    }
    
    enum AnimatedItemLocation {
        case before
        case after
        case selected
    }
    
    var selectedIndexPath: IndexPath?
    private var firstItemIndexPath: IndexPath?
    private var lastItemIndexPath: IndexPath?
    private var itemsOnScreen: [UICollectionViewCell]!
    
    // MARK: - Public methods
    func animateItems(withType type: AnimationType, andDirection direction: AnimationDirection) {
        guard numberOfItems(inSection: 0) != 0 else {
            switch direction {
            case .fromScreen:
                fromScreenFinishedCallback?()
                fromScreenFinishedCallback = nil
            case .backToScreen, .backToScreenAfterAddItem:
                backToScreenFinishedCallback?()
                backToScreenFinishedCallback = nil
            }
            return
        }
        
        setupItemsOnScreen()
        setupIndexPaths(direction: direction)
        
        
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
    
    func setAnimations(_ item: UICollectionViewCell, transform: CGAffineTransform, type: AnimationType, direction: AnimationDirection, location: AnimatedItemLocation, delay: TimeInterval) {
            item.transform = transform
    }
    
    // MARK: - Private methods
    private func animate(_ item: UICollectionViewCell,
                         withType type: AnimationType,
                         andDirection direction: AnimationDirection,
                         andLocation location: AnimatedItemLocation) {
        let isNeedToCheckIfItemUnderMenuBar = location != .after && direction == .fromScreen && type != .editMode
        if isNeedToCheckIfItemUnderMenuBar {
            hideIfNeeded(item)
        }
        
        let delay = setupAnimationParamDelay(for: item, withType: type, andDirection: direction, andLocation: location)
        let transform = setupAnimationParamTransform(for: item, withType: type, andDirection: direction, andLocation: location)
        let completion = setupAnimationParamCompletion(for: item, withType: type, andDirection: direction, andLocation: location)
        
        UIView.animate(withDuration: AppStyle.animationDuration,
                       delay: delay,
                       options: .curveEaseInOut,
                       animations: {
                        self.setAnimations(item, transform: transform, type: type, direction: direction, location: location, delay: delay)
                       },
                       completion: completion)
    }
    
    private func setupAnimationParamDelay(for item: UICollectionViewCell,
                                          withType type: AnimationType,
                                          andDirection direction: AnimationDirection,
                                          andLocation location: AnimatedItemLocation) -> TimeInterval {
        
        var delay: TimeInterval = 0.0
        let itemIndexPath = self.indexPath(for: item)!
        if type == .watchItemSelected {
            switch direction {
            case .fromScreen:
                switch location {
                case .before:   delay = 0.1 * Double(itemIndexPath.item - firstItemIndexPath!.item + 1)
                case .after:    delay = 0.1 * Double(lastItemIndexPath!.item - itemIndexPath.item + 1)
                case .selected: delay = 0.1 * Double(max(lastItemIndexPath!.item - selectedIndexPath!.item, selectedIndexPath!.item - firstItemIndexPath!.item) + 1)
                }
            case .backToScreen, .backToScreenAfterAddItem:
                switch location {
                case .before:   delay = 0.1 * Double(selectedIndexPath!.item - itemIndexPath.item)
                case .after:    delay = 0.1 * Double(itemIndexPath.item - selectedIndexPath!.item)
                case .selected: delay = 0.0
                }
            }
            
        } else if type == .searchItemSelected {
            switch direction {
            case .fromScreen:
                switch location {
                case .before:   delay = 0.1 * Double(itemIndexPath.item - firstItemIndexPath!.item + 1)
                case .after:    delay = 0.1 * Double(lastItemIndexPath!.item - itemIndexPath.item + 1)
                case .selected:
                    delay = 0.1 * Double(max(lastItemIndexPath!.item - selectedIndexPath!.item, selectedIndexPath!.item - firstItemIndexPath!.item) + 1)
                }
            default: break
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
            case .backToScreenAfterAddItem:
                delay = 0.1 * Double(itemIndexPath.item - selectedIndexPath!.item)
            }
        } else if type == .editMode {
            delay = 0.0
        }
        return delay
    }
    
    private func setupAnimationParamTransform(for item: UICollectionViewCell,
                                              withType type: AnimationType,
                                              andDirection direction: AnimationDirection,
                                              andLocation location: AnimatedItemLocation) -> CGAffineTransform {
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        if type == .watchItemSelected {
            switch direction {
            case .fromScreen:
                switch location {
                case .before:
                    transform = CGAffineTransform(translationX: 0, y: -1000)
                case .after:
                    transform = CGAffineTransform(translationX: 0, y: 1000)
                case .selected:
                    let frameInView = self.superview!.convert(item.frame, from: self)
                    transform = CGAffineTransform(translationX: 0, y: -(frameInView.minY - AppStyle.topSafeAreaHeight))
                }
            case .backToScreen, .backToScreenAfterAddItem:
                transform = CGAffineTransform.identity
            }
            
        } else if type == .searchItemSelected {
            switch direction {
            case .fromScreen:
                switch location {
                case .before:
                    transform = CGAffineTransform(translationX: 0, y: -1000)
                case .after:
                    transform = CGAffineTransform(translationX: 0, y: 1000)
                case .selected:
                    transform = CGAffineTransform(translationX: 0, y: -000.1) //грязный хук, чтобы было хоть какое-то изменение transform, иначе не работает
                }
            default: break
            }
        } else if type == .allItems {
            switch direction {
            case .fromScreen:
                transform = CGAffineTransform(translationX: 0, y: 1000)
            case .backToScreen:
                transform = CGAffineTransform.identity
            case .backToScreenAfterAddItem:
                let frameInView = self.superview!.convert(item.frame, from: self)
                let deltaY = AppStyle.menuBarFullHeight - (frameInView.minY - 1000) + (AppStyle.itemHeight + AppStyle.itemsLineSpacing) * CGFloat(indexPath(for: item)!.row + 1)
                transform = (CGAffineTransform.identity).translatedBy(x: 0, y: deltaY)
            }
        } else if type == .editMode {
            switch direction {
            case .fromScreen:
                switch location {
                case .before:
                    transform = CGAffineTransform(translationX: 0, y: -AppStyle.watchItemEditTranslationY)
                case .after:
                    transform = CGAffineTransform(translationX: 0, y: AppStyle.watchItemEditTranslationY)
                case .selected:
                    let scale = AppStyle.watchItemEditMinimizeScale
                    transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            case .backToScreen, .backToScreenAfterAddItem:
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
        
        if type == .watchItemSelected {
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
            case .backToScreen, .backToScreenAfterAddItem:
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
        } else if type == .searchItemSelected {
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
            default: break
            }
        } else if type == .allItems || type == .editMode {
            switch direction {
            case .fromScreen, .backToScreen, .backToScreenAfterAddItem:
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
                fromScreenFinishedCallback = nil
            }
        } else if direction == .backToScreen || direction == .backToScreenAfterAddItem {
            let itemIndexPath = indexPath(for: item)
            
            let itemWasRemoved = itemIndexPath == nil
            guard !itemWasRemoved else {
                backToScreenFinishedCallback?()
                selectedIndexPath = nil
                return }
            
            var isWholeAnimationFinished: Bool
            if type == .editMode || direction == .backToScreenAfterAddItem {
                isWholeAnimationFinished = true
            } else {
                isWholeAnimationFinished = itemIndexPath == self.firstItemIndexPath!
            }
            
            if isWholeAnimationFinished {
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
    
    private func setupIndexPaths(direction: AnimationDirection) {
        firstItemIndexPath = self.indexPath(for: itemsOnScreen.first!)!
        lastItemIndexPath = self.indexPath(for: itemsOnScreen.last!)!
        
        if selectedIndexPath == nil {
            selectedIndexPath = firstItemIndexPath
        }
        
        if direction == .backToScreenAfterAddItem {
            selectedIndexPath = IndexPath(item: 0, section: 0)
            firstItemIndexPath = selectedIndexPath
        }
    }
    
}
