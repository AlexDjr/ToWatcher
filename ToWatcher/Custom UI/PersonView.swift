//
//  PersonView.swift
//  ToWatcher
//
//  Created by Alex Delin on 07.03.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import UIKit

class PersonView: UIView {
    private var roundedView = UIView(frame: CGRect(x: 0, y: 0, width: AppStyle.personImageViewHeight, height: AppStyle.personImageViewHeight))
    
    private var itemImageView: UIImageView = {
        let itemImageView = UIImageView(image: nil)
        itemImageView.contentMode = .scaleAspectFill
        return itemImageView
    }()
    
    private var nameLabel = UILabel().set(font: UIFont(name: AppStyle.appFontNameRegular, size: AppStyle.watchItemInfoLabelsFontSize)!,
                                          color: AppStyle.watchItemInfoLabelsTextColor,
                                          numberOfLines: 3,
                                          minimumScale: 1.0,
                                          alignment: .center)
    
    var person: Person?
    
    convenience init(_ person: Person) {
        self.init(frame: CGRect.zero)
        self.person = person
        nameLabel.text = person.name
        setImage(person.imageURL)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundedView.roundCorners([.allCorners], radius: self.frame.height / 2)
    }
    
    
    // MARK: - Private methods
    private func setImage(_ imageURL: URL) {
        itemImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder")!)
    }
    
    private func setupView() {
        setupImageView()
        setupStackView()
    }
    
    private func setupImageView() {
        roundedView.addSubview(itemImageView)
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.topAnchor.constraint(equalTo: roundedView.topAnchor).isActive = true
        itemImageView.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor).isActive = true
        itemImageView.leftAnchor.constraint(equalTo: roundedView.leftAnchor).isActive = true
        itemImageView.rightAnchor.constraint(equalTo: roundedView.rightAnchor).isActive = true
    }
    
    private func setupStackView() {
        let vStack = UIStackView().set(axis: .vertical, spacing: 4.0, alignment: .center)
        
        vStack.addArrangedSubview(roundedView)
        vStack.addArrangedSubview(nameLabel)
        
        roundedView.heightAnchor.constraint(equalToConstant: AppStyle.personImageViewHeight).isActive = true
        roundedView.widthAnchor.constraint(equalToConstant: AppStyle.personImageViewHeight).isActive = true
        
        self.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        vStack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        vStack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
}
