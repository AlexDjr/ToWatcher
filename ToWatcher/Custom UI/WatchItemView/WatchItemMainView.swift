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
    private var roundedView = UIView()
    
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

    override func layoutSubviews() {
        super.layoutSubviews()
        addShadow(AppStyle.itemRoundCorners, radius: self.frame.height * AppStyle.itemCornerRadiusCoeff)
        roundedView.roundCorners(AppStyle.itemRoundCorners, radius: self.frame.height * AppStyle.itemCornerRadiusCoeff)
    }
    
    // MARK: Public methods
    func setImage(_ image: UIImage) {
        itemImageView.image = image
    }

    func setupState(_ state: WatchItemCellState) {
        switch state {
        case .enabled: removeFilterFromImageIfNeeded()
        case .disabled: addFilterToImage()
        default: break
        }
    }
    
    // MARK: - Private methods
    private func setupView() {
        addSubview(roundedView)
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        roundedView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        roundedView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        roundedView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        roundedView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        roundedView.addSubview(itemImageView)
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.topAnchor.constraint(equalTo: roundedView.topAnchor).isActive = true
        itemImageView.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor).isActive = true
        itemImageView.leftAnchor.constraint(equalTo: roundedView.leftAnchor).isActive = true
        itemImageView.rightAnchor.constraint(equalTo: roundedView.rightAnchor).isActive = true
    }
    
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
        
        UIView.transition(with: itemImageView,
                          duration: AppStyle.animationDuration,
                          options: .transitionCrossDissolve,
                          animations: { self.itemImageView.image = newImage },
                          completion: nil)
    }
    
    private func removeFilterFromImageIfNeeded() {
        guard let originalImage = originalImage else { return }
        
        UIView.transition(with: itemImageView,
                          duration: AppStyle.animationDuration,
                          options: .transitionCrossDissolve,
                          animations: { self.itemImageView.image = originalImage },
                          completion: { _ in self.originalImage = nil } )
    }
    
}
