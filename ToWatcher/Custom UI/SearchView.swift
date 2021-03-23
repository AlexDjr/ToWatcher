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
    var delegate: SearchDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private methods
    private func setupView() {
        textField = UITextField()
        textField.backgroundColor = AppStyle.mainBGColor
        textField.tintColor = AppStyle.searchViewTextColor
        textField.textColor = AppStyle.searchViewTextColor
        textField.font = UIFont(name: AppStyle.appFontNameBold, size: AppStyle.watchItemInfoLocalTitleFontSize)
        textField.autocapitalizationType = .none
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
        
        let clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 22.0, height: 14.0))
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        clearButton.setImage(#imageLiteral(resourceName: "clear-icon"), for: .normal)
        textField.rightView = clearButton
    }
    
    @objc private func clear() {
        textField.text = nil
        hideClearButton()
        delegate?.didSearchTextChanged("")
        textField.becomeFirstResponder()
    }
    
    private func showOrHideClearButton(_ string: String?) {
        if string ?? "" == "" {
            hideClearButton()
        } else {
            showClearButton()
        }
    }
    
    private func showClearButton() {
        textField.rightViewMode = .always
    }
    
    private func hideClearButton() {
        textField.rightViewMode = .never
    }
}


extension SearchView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var searchString = ""
        
        if let text = textField.text, let textRange = Range(range, in: text) {
            searchString = text.replacingCharacters(in: textRange, with: string)
        }
        
        showOrHideClearButton(searchString)
        delegate?.didSearchTextChanged(searchString)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showOrHideClearButton(textField.text)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        showOrHideClearButton(textField.text)
    }
}
