//
//  SearchVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 07/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    private var searchView: SearchView!
    
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
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.alpha = 0.0
        
        setupSearchView()
        animateShowView()
        setFocusOnSearchView()
    }
    
    private func setupSearchView() {
        searchView = SearchView()
        view.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.topAnchor.constraint(equalTo: view.topAnchor, constant: AppStyle.searchViewTopPadding).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: AppStyle.searchViewHeight).isActive = true
        searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: AppStyle.searchViewLeftRightPadding).isActive = true
        searchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -AppStyle.searchViewLeftRightPadding).isActive = true
    }
    
    private func animateShowView() {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1.0
        }
    }
    
    private func setFocusOnSearchView() {
        searchView.textField.becomeFirstResponder()
    }
}
