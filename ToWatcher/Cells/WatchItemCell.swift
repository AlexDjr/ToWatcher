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
    
    weak var delegate: WatchItemEditProtocol?
    
    var state: WatchItemCellState = .enabled
    
    private lazy var watchItmeView = WatchItemView(self)
    
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
    
    func setupState(_ state: WatchItemCellState = .enabled, isForReused: Bool = false) {
        self.state = state
        watchItmeView.setupState(state)
        
        switch state {
        case .enabled, .editing:
            isUserInteractionEnabled = true
        case .disabled:
            isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Private methods
    private func setupView() {
        contentView.addSubview(watchItmeView)
        watchItmeView.translatesAutoresizingMaskIntoConstraints = false
        watchItmeView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        watchItmeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        watchItmeView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        watchItmeView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
}
