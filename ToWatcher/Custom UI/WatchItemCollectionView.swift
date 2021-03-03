//
//  WatchItemCollectionView.swift
//  ToWatcher
//
//  Created by Alex Delin on 10.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

class WatchItemCollectionView: AnimatableCollectionView {
    
    override func setAnimations(_ item: UICollectionViewCell, transform: CGAffineTransform, type: AnimatableCollectionView.AnimationType, direction: AnimatableCollectionView.AnimationDirection, location: AnimatableCollectionView.AnimatedItemLocation, delay: TimeInterval) {
        guard let watchItemCell = item as? WatchItemCell else { item.transform = transform; return }
        
        watchItemCell.setTransform(transform, type: type, direction: direction)
        if type == .watchItemSelected && location == .selected {
            switch direction {
            case .fromScreen: watchItemCell.hideLabels()
            case .backToScreen: watchItemCell.showLabels()
            default: break
            }
        }
    }

    func goToEditMode() {
        for i in 0...self.numberOfItems(inSection: 0) - 1 {
            let indexPath = IndexPath(item: i, section: 0)
            guard let cell = self.cellForItem(at: indexPath) as? WatchItemCell else { continue }
            
            if indexPath == selectedIndexPath {
                cell.setupState(.editing(.default))
            } else {
                cell.setupState(.disabled)
            }
        }
    }
    
    func goFromEditMode() {
        for i in 0...self.numberOfItems(inSection: 0) - 1 {
            let indexPath = IndexPath(item: i, section: 0)
            guard let cell = self.cellForItem(at: indexPath) as? WatchItemCell else { continue }
            
            if cell.state != .enabled {
                cell.setupState(.enabled)
            }
        }
    }
}
