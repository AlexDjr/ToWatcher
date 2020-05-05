//
//  BottomButton.swift
//  ToWatcher
//
//  Created by Alex Delin on 27/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class FloatActionButton: UIButton  {
    var actionState: ActionState {
        didSet { changeState() }
    }
    
    var isButtonHidden: Bool = true {
        didSet { changeVisibility() }
    }
    
    override init(frame: CGRect) {
        actionState = .add
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupButton() {
        backgroundColor = AppStyle.floatActionButtonBGColor
        layer.cornerRadius = AppStyle.floatActionButtonHeight / 2
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        setImage(AppStyle.floatActionBarIconImage.withRenderingMode(.alwaysTemplate), for: .normal)
        setImage(AppStyle.floatActionBarIconImage.withRenderingMode(.alwaysTemplate), for: .highlighted)
        //  this is to prevent strange behaviour of imageView while rotating
        imageView?.clipsToBounds = false
        imageView?.contentMode = .center
    }
    
    private func changeState() {
        var transform: CGAffineTransform? = nil
        var tintColor: UIColor? = nil
        
        let rotatingAngle = CGFloat(Double.pi / 2 + Double.pi / 4)
        switch actionState {
        case .add:
            transform = imageView!.transform.rotated(by: -rotatingAngle)
            tintColor = AppStyle.floatActionButtonIconAddColor
        case .close:
            transform = imageView!.transform.rotated(by: rotatingAngle)
            tintColor = AppStyle.floatActionButtonIconCloseColor
        }
        UIView.animate(withDuration: AppStyle.animationDuration) {
            self.imageView?.transform = transform!
            self.imageView?.tintColor = tintColor!
        }
    }

    private func changeVisibility() {
        var alpha: CGFloat
        
        if isButtonHidden {
            alpha = 0.0
        } else {
            alpha = 1.0
        }
        
        UIView.animate(withDuration: AppStyle.animationDuration) {
            self.alpha = alpha
        }
    }
    
    // MARK: - Private types
    enum ActionState {
        case add
        case close
    }
}
