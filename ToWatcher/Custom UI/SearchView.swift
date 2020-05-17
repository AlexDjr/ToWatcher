//
//  SearchView.swift
//  ToWatcher
//
//  Created by Alex Delin on 17.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

class SearchView: UIView {
    var textField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private methods
    private func setupView() {
        textField = UITextField()
        textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textField.tintColor = AppStyle.searchViewTintColor
        textField.font = UIFont(name: AppStyle.appFontNameBold, size: AppStyle.watchItemInfoLocalTitleFontSize)
        textField.addBottomBorder()
        
        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        let iconImageView = UIImageView(image: #imageLiteral(resourceName: "search-icon"))
        textField.leftView = iconImageView
        textField.leftViewMode = .always
    }
}
