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
                self.imageView?.tintColor = #colorLiteral(red: 0, green: 0.5529411765, blue: 0.8352941176, alpha: 1)
            case .close:
                self.imageView?.tintColor = #colorLiteral(red: 0.2156862745, green: 0.2784313725, blue: 0.3137254902, alpha: 1)
            }
        }
    }
    
    override init(frame: CGRect) {
        actionState = .add
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.cornerRadius = 28
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), for: .normal)
        setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), for: .highlighted)
        //  this is to prevent strange behaviour of imageView while rotating
        imageView?.clipsToBounds = false
        imageView?.contentMode = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
