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
    
    var state: State = .enabled {
        didSet { setupState() }
    }
    
    private var watchItmeView = WatchItemView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public methods
    func setImage(_ image: UIImage) {
        watchItmeView.setImage(image)
    }
    
    // MARK: - Private methods
    private func setupView() {
        contentView.addSubview(watchItmeView)
        watchItmeView.translatesAutoresizingMaskIntoConstraints = false
        watchItmeView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        watchItmeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        watchItmeView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        watchItmeView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        // TODO: Fix shadow
        setupRoundCornersForCell()
        setupShadowForCell()
    }
    
    private func setupRoundCornersForCell() {
        self.contentView.layer.roundCorners([.topRight, .bottomLeft], radius: AppStyle.itemCornerRadius)
    }
    
    private func setupShadowForCell() {
        layer.masksToBounds = false
//        contentView.layer.masksToBounds = false
//        clipsToBounds = false
//        contentView.clipsToBounds = false
        
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: -3, height: 4)
    }
    
    // MARK: - State
    private func setupState() {
        watchItmeView.setupState(state)
        
        switch state {
        case .enabled, .editing:
            isUserInteractionEnabled = true
        case .disabled:
            isUserInteractionEnabled = false
        }
    }
    
    enum State {
        case enabled
        case disabled
        case editing
    }
}
