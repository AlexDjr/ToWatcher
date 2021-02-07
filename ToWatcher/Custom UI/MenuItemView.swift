//
//  MenuItemView.swift
//  ToWatcher
//
//  Created by Alex Delin on 11.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

class MenuItemView: UIView {
    var menuItem: MenuItem! {
        didSet {
            itemImageView.image = menuItem.image
            itemNameLabel.text = menuItem.name
            
            if menuItem.counter == 0 {
                UIView.animate(withDuration: 0.2) {
                    self.counterView.alpha = 0.0
                }
            } else {
                counterView.alpha = 1.0
                
                countLabel.text = String(menuItem.counter)
                counterWidthConstraint.constant = widthConstant
            }
        }
    }
    
    private var counterWidthConstraint: NSLayoutConstraint!
    private var widthConstant: CGFloat { (String(menuItem?.counter ?? 0) as NSString).size(withAttributes: [NSAttributedString.Key.font: AppStyle.menuItemCounterFont]).width + 16.0 }
    
    private var itemImageView: UIImageView = UIImageView(image: nil)
    private var itemNameLabel: UILabel = {
        let itemNameLabel = UILabel()
        itemNameLabel.font = UIFont(name: AppStyle.appFontNameBold, size: AppStyle.menuItemFontSize)
        return itemNameLabel
    }()
    
    private var counterView = UIView()
    private var countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public methods
    func setupState(_ state: MenuItemState) {
        guard menuItem.type != .empty else { return }
        
        switch state {
        case .active:
            itemNameLabel.textColor = AppStyle.menuItemActiveTextColor
            itemImageView.image = itemImageView.image?.withRenderingMode(.alwaysOriginal)
            
            switch menuItem.type {
            case .toWatch: countLabel.textColor = AppStyle.menuItemToWatchCounterColor
            case .watched: countLabel.textColor = AppStyle.menuItemWatchedCounterColor
            default: break
            }
        case .inactive:
            itemNameLabel.textColor = AppStyle.menuItemInactiveTextColor
            itemImageView.image = itemImageView.image?.withRenderingMode(.alwaysTemplate)
            itemImageView.tintColor = AppStyle.menuItemInactiveTextColor
            countLabel.textColor = AppStyle.menuItemInactiveTextColor
        }
    }
    
    // MARK: - Private methods
    private func setupView() {
        setupStackView()
        setupCounterView()
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        
        stackView.addArrangedSubview(itemImageView)
        stackView.addArrangedSubview(itemNameLabel)
        
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setupCounterView() {
        counterView = UIView()
        counterView.backgroundColor = AppStyle.mainBGColor
        counterView.layer.cornerRadius = 13.0
        
        itemImageView.addSubview(counterView)
        counterView.translatesAutoresizingMaskIntoConstraints = false
        counterView.topAnchor.constraint(equalTo: itemImageView.topAnchor, constant: -8.0).isActive = true
        counterView.leftAnchor.constraint(equalTo: itemImageView.centerXAnchor, constant: 10.0).isActive = true
        counterView.heightAnchor.constraint(equalTo: itemImageView.heightAnchor, multiplier: 0.5).isActive = true
        counterWidthConstraint = counterView.widthAnchor.constraint(equalToConstant: widthConstant)
        counterWidthConstraint.isActive = true
        
        countLabel = UILabel()
        countLabel.font = AppStyle.menuItemCounterFont
        
        counterView.addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.leftAnchor.constraint(equalTo: counterView.leftAnchor, constant: 8.5).isActive = true
        countLabel.centerYAnchor.constraint(equalTo: counterView.centerYAnchor).isActive = true
    }
}
