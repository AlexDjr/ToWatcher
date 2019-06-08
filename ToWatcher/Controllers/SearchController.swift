//
//  SearchController.swift
//  ToWatcher
//
//  Created by Alex Delin on 07/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    lazy var searchTextField: UITextField = {
        return setupSearchTextField()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    //    MARK: - Methods
    func setupView() {
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupSearchTextFieldView()
    }
    
    private func setupSearchTextFieldView() {
        setupSearchImageView()
        setupSearchTextFieldLayout()
    }
    
    private func setupSearchTextFieldLayout() {
        view.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: AppStyle.searchTextFieldTopPadding).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: AppStyle.searchTextFieldHeight).isActive = true
        searchTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: AppStyle.searchTextFieldLeftRightPadding).isActive = true
        searchTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -AppStyle.searchTextFieldLeftRightPadding).isActive = true
    }
    
    private func setupSearchImageView() {
        let iconImageView = UIImageView(image: #imageLiteral(resourceName: "search-icon"))
        searchTextField.leftView = iconImageView
        searchTextField.leftViewMode = .always
    }
    
    private func setupSearchTextField() -> UITextField {
        let searchTextField = UITextField()
        searchTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        searchTextField.tintColor = AppStyle.searchTextFieldTintColor
        searchTextField.font = UIFont(name: AppStyle.appFontNameBold, size: AppStyle.watchItemInfoLocalTitleFontSize)
        searchTextField.addBottomBorder()
        searchTextField.becomeFirstResponder()
        
        return searchTextField
    }
}
