//
//  ActionView.swift
//  SwipeTest
//
//  Created by Alex Delin on 02.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

class WatchItemActionView: UIView {
    var initialConstraint = NSLayoutConstraint()
    var activeConstraint = NSLayoutConstraint()
    var actionView = UIView()
    
    private var actionViewType: ActionViewType
    
    init(_ actionViewType: ActionViewType) {
        self.actionViewType = actionViewType
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupView() {
//        layer.masksToBounds = false
        
        switch actionViewType {
        case .watched: backgroundColor = .systemGreen
        case .delete: backgroundColor = .systemRed
        }
        
        self.alpha = 0.0
        setupActionView()
    }
    
    private func setupActionView() {
        actionView.backgroundColor = .clear
        
        self.addSubview(actionView)
        actionView.translatesAutoresizingMaskIntoConstraints = false
        
        switch actionViewType {
        case .watched:
            backgroundColor = .systemGreen

            actionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            actionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            actionView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
            
            initialConstraint = actionView.leftAnchor.constraint(equalTo: self.leftAnchor)
            initialConstraint.isActive = true
            
        case .delete:
            backgroundColor = .systemRed
            
            actionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            actionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            actionView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
            
            initialConstraint = actionView.rightAnchor.constraint(equalTo: self.rightAnchor)
            initialConstraint.isActive = true
        }
        
        setupImageView()
    }
    
    private func setupImageView() {
        let imageView = UIImageView()
        
        switch actionViewType {
        case .watched: imageView.image = #imageLiteral(resourceName: "action_view_watched")
        case .delete: imageView.image = #imageLiteral(resourceName: "action_view_delete")
        }
        
        actionView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: actionView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: actionView.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
    }
}

enum ActionViewType {
    case watched
    case delete
}
