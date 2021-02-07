//
//  WatchItemCell.swift
//  ToWatcher
//
//  Created by Alex Delin on 30/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class WatchItemCell: UICollectionViewCell {
    weak var delegate: WatchItemEditProtocol?
    
    var state: WatchItemCellState = .enabled
    var watchItem: WatchItem? {
        didSet {
            guard let watchItem = watchItem else { return }
            watchItemView.setWatchItemInfo(watchItem)
        }
    }
    
    private lazy var watchItemView = WatchItemView(self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public methods
    func setupState(_ state: WatchItemCellState = .enabled, isForReused: Bool = false) {
        self.state = state
        watchItemView.setupState(state)
        
        switch state {
        case .enabled, .editing:
            isUserInteractionEnabled = true
        case .disabled:
            isUserInteractionEnabled = false
        }
    }
    
    func setTransform(_ transform: CGAffineTransform, type: AnimatableCollectionView.AnimationType, direction: AnimatableCollectionView.AnimationDirection) {
        guard type == .editMode else { self.transform = transform; return }
    
        let yScale = sqrt(transform.b * transform.b + transform.d * transform.d)
        
        switch direction {
        case .fromScreen:
            watchItemView.mainView.transform = transform
            watchItemView.deleteView.transform = .init(scaleX: 1, y: yScale)
            watchItemView.watchedView.transform = .init(scaleX: 1, y: yScale)
            
        case .backToScreen, .backToScreenAfterAddItem:
            watchItemView.mainView.transform = .identity
            watchItemView.deleteView.transform = .identity
            watchItemView.watchedView.transform = .identity
        }
    }
    
    // MARK: - Private methods
    private func setupView() {
        contentView.addSubview(watchItemView)
        watchItemView.translatesAutoresizingMaskIntoConstraints = false
        watchItemView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        watchItemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        watchItemView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        watchItemView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
}
