//
//  AnimatableCollectionView.swift
//  ToWatcher
//
//  Created by Alex Delin on 21.04.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

extension AnimatableCollectionView {
    func switchSelectedItemToEditMode() {
        for i in 0...self.numberOfItems(inSection: 0) - 1 {
            let indexPath = IndexPath(item: i, section: 0)
            guard let cell = self.cellForItem(at: indexPath) as? WatchItemCell else { continue }
            
            if indexPath == selectedIndexPath {
                cell.state = .editing
            } else {
                cell.state = .disabled
            }
        }
    }
    
    func enableAllCells() {
        for i in 0...self.numberOfItems(inSection: 0) - 1 {
            let indexPath = IndexPath(item: i, section: 0)
            if let cell = self.cellForItem(at: indexPath) as? WatchItemCell, cell.state != .enabled {
                cell.state = .enabled
            }
        }
    }
}
