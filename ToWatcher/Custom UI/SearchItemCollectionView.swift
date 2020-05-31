//
//  SearchItemCollectionView.swift
//  ToWatcher
//
//  Created by Alex Delin on 30.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

class SearchItemCollectionView: AnimatableCollectionView {
    override func setTransform(_ item: UICollectionViewCell, transform: CGAffineTransform, type: AnimatableCollectionView.AnimationType, direction: AnimatableCollectionView.AnimationDirection, location: AnimatableCollectionView.AnimatedItemLocation) {
        if let _ = item as? SearchItemCell, type == .itemSelected, location == .selected {
            let frameInView = self.superview!.convert(item.frame, from: self)
            let transform = CGAffineTransform(translationX: 0, y: -(frameInView.minY - AppStyle.menuBarFullHeight - 50))
            
            item.transform = transform
        } else {
            item.transform = transform
        }
    }
}
