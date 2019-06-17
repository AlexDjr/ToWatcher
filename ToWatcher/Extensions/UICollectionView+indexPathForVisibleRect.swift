//
//  UICollectionView+indexPathForVisibleRect.swift
//  ToWatcher
//
//  Created by Alex Delin on 17/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

extension UICollectionView {
    func indexPathForVisibleItem(withOffset offset: CGPoint) -> IndexPath? {
        let visibleRect = CGRect(origin: offset, size: self.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = self.indexPathForItem(at: visiblePoint) else { return nil }
        
        return indexPath
    }
}
