//
//  SearchItemCollectionView.swift
//  ToWatcher
//
//  Created by Alex Delin on 30.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

class SearchItemCollectionView: AnimatableCollectionView {
    override func setAnimations(_ item: UICollectionViewCell, transform: CGAffineTransform, type: AnimatableCollectionView.AnimationType, direction: AnimatableCollectionView.AnimationDirection, location: AnimatableCollectionView.AnimatedItemLocation, delay: TimeInterval) {
        if let item = item as? SearchItemCell, type == .searchItemSelected, location == .selected {
            
            let frameInSuperview = self.superview!.convert(item.frame, from: self)
            let transform = item.getAnimationTransform(with: frameInSuperview.minY)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { item.hideInfo() }
            item.transform = transform
        } else {
            item.transform = transform
        }
    }
}
