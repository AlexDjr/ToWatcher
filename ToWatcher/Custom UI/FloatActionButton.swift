//
//  BottomButton.swift
//  ToWatcher
//
//  Created by Alex Delin on 27/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class FloatActionButton: UIButton  {
    
    enum ActionState {
        case add
        case close
    }
    
    var actionState: ActionState {
        didSet {
            switch actionState {
            case .add:
                self.imageView?.tintColor = AppStyle.floatActionButtonIconAddColor
            case .close:
                self.imageView?.tintColor = AppStyle.floatActionButtonIconCloseColor
            }
        }
    }
    
    override init(frame: CGRect) {
        actionState = .add
        super.init(frame: frame)
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func change(_ state: ActionState) {
        switch state {
        case .add:
            imageView?.transform = imageView!.transform.rotated(by: CGFloat(-Double.pi / 2 - Double.pi / 4))
        case .close:
            imageView?.transform = imageView!.transform.rotated(by: CGFloat(Double.pi / 2 + Double.pi / 4))
        }
        actionState = state
    }

}
