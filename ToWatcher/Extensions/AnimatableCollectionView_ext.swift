//
//  AnimatableCollectionView.swift
//  ToWatcher
//
//  Created by Alex Delin on 21.04.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

extension AnimatableCollectionView {
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
