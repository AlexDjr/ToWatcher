//
//  SearchVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 07/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    lazy var searchTextField: UITextField = {
        return setupSearchTextField()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.alpha = 0.0
        
        setupSearchTextFieldView()
        animateShowView()
        setFocusOnSearchTextFieldView()
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
        
        return searchTextField
    }
    
    private func animateShowView() {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1.0
        }
    }
    
    private func setFocusOnSearchTextFieldView() {
        searchTextField.becomeFirstResponder()
    }
}
