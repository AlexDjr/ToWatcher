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
    
    private var originalImage: UIImage?
    
    var itemImage: UIImage? {
        didSet {
            itemImageView.image = itemImage
        }
    }
    
    var state: State = .enabled {
        didSet {
            setupState()
        }
    }
    
    var itemImageView: UIImageView = {
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
    
    // MARK: - Private methods
    private func setupCell() {
        contentView.addSubview(itemImageView)
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        itemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        itemImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        itemImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        setupRoundCornersForCell()
        setupShadowForCell()
    }
    
    private func setupRoundCornersForCell() {
        self.contentView.layer.roundCorners([.topRight, .bottomLeft], radius: AppStyle.itemCornerRadius)
    }
    
    private func setupShadowForCell() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: -3, height: 4)
    }
    
    // MARK: - State
    private func setupState() {
        switch state {
        case .enabled:
            isUserInteractionEnabled = true
            removeFilterFromImage()
        case .disabled:
            isUserInteractionEnabled = false
            addFilterToImage()
        }
    }
    
    private func addFilterToImage() {
        originalImage = itemImage
        
        let ciImage = CIImage(image: itemImage!)!
        let blackAndWhiteImage = ciImage.applyingFilter("CIColorControls", parameters: ["inputSaturation": 0, "inputContrast": 1, "inputBrightness": 0.015])
        let newImage = UIImage(ciImage: blackAndWhiteImage)
        
        // TODO: Change color simultaneously with moving animation
        UIView.transition(with: itemImageView,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: { self.itemImageView.image = newImage },
                          completion: nil)
    }
    
    private func removeFilterFromImage() {
        UIView.transition(with: itemImageView,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: { self.itemImageView.image = self.originalImage },
                          completion: { _ in self.originalImage = nil } )
    }
    
    enum State {
        case enabled
        case disabled
    }
}
