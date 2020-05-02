//
//  WatchItemMainView.swift
//  SwipeTest
//
//  Created by Alex Delin on 02.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

class WatchItemMainView: UIView {
    private var originalImage: UIImage?
    
    private var itemImageView: UIImageView = {
        let itemImageView = UIImageView(image: nil)
        itemImageView.contentMode = .scaleAspectFill
        return itemImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public methods
    func setImage(_ image: UIImage) {
        itemImageView.image = image
    }

    func setupState(_ state: WatchItemCell.State) {
        switch state {
        case .enabled: removeFilterFromImageIfNeeded()
        case .disabled: addFilterToImage()
        default: break
        }
    }
    
    // MARK: - Private methods
    private func setupView() {
        self.addSubview(itemImageView)
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        itemImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        itemImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        itemImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
//        setupRoundCornersForCell()
//        setupShadowForCell()
    }
    
//    private func setupRoundCornersForCell() {
//        self.contentView.layer.roundCorners([.topRight, .bottomLeft], radius: AppStyle.itemCornerRadius)
//    }
//
//    private func setupShadowForCell() {
//        layer.masksToBounds = false
//        layer.shadowOpacity = 0.15
//        layer.shadowRadius = 3
//        layer.shadowOffset = CGSize(width: -3, height: 4)
//    }
    
    // MARK: - State
    private func addFilterToImage() {
        originalImage = itemImageView.image
        
        let ciImage = CIImage(image: itemImageView.image!)!
        //        let blackAndWhiteImage = ciImage.applyingFilter("CIColorControls", parameters: ["inputSaturation": 0, "inputContrast": 1, "inputBrightness": 0.015])
        //        let blackAndWhiteImage = ciImage.applyingFilter("CIColorMonochrome", parameters: ["inputColor": CIColor.gray, "inputIntensity": 1])
        //        let blackAndWhiteImage = ciImage.applyingFilter("CIPhotoEffectMono", parameters: [:])
        //        let blackAndWhiteImage = ciImage.applyingFilter("CIPhotoEffectNoir", parameters: [:])
        let blackAndWhiteImage = ciImage.applyingFilter("CIPhotoEffectTonal", parameters: [:])
        let newImage = UIImage(ciImage: blackAndWhiteImage)
        
        // TODO: Change color simultaneously with moving animation
        UIView.transition(with: itemImageView,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: { self.itemImageView.image = newImage },
                          completion: nil)
    }
    
    private func removeFilterFromImageIfNeeded() {
        guard let originalImage = originalImage else { return }
        
        UIView.transition(with: itemImageView,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: { self.itemImageView.image = originalImage },
                          completion: { _ in self.originalImage = nil } )
    }
    
}

