//
//  ItemCell.swift
//  ToWatcher
//
//  Created by Alex Delin on 17/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class ContainerCell: UICollectionViewCell {
    static let reuseIdentifier = "containerCell"
    
    var hostedView: UIView? {
        didSet {
            guard let hostedView = hostedView else {
                return
            }
            
            hostedView.frame = contentView.bounds
            contentView.addSubview(hostedView)
        }
    }
}
