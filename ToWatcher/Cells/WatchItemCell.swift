//
//  WatchItemCell.swift
//  ToWatcher
//
//  Created by Alex Delin on 30/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class WatchItemCell: UICollectionViewCell {
    static let reuseIdentifier = "watchItemCell"
    
    var itemImage: UIImage? {
        didSet {
            itemImageView.image = itemImage
        }
    }
    
    private var itemImageView: UIImageView = {
        let itemImageView = UIImageView(image: nil)
        itemImageView.contentMode = .scaleAspectFill
        return itemImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.addSubview(itemImageView)
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        itemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        itemImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        itemImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        self.layer.roundCorners([.topRight, .bottomLeft], radius: round(AppStyle.itemHeight * 0.42))
    }
}
