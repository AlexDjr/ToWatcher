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
            contentView.addSubview(hostedView)
            hostedView.translatesAutoresizingMaskIntoConstraints = false
            hostedView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            hostedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            hostedView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            hostedView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        }
    }
}
