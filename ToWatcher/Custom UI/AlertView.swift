//
//  AlertView.swift
//  ToWatcher
//
//  Created by Alex Delin on 13.03.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import UIKit

class AlertView: UIView {
    private var heightConstraint: NSLayoutConstraint?
    private var alertHeight: CGFloat = AppStyle.alertViewHeight
    
    private var alertImageView = UIImageView(image: AppStyle.alertImage)
    private var alertLabel = UILabel().set(font: UIFont(name: AppStyle.appFontNameSemiBold, size: AppStyle.searchItemLocalTitleFontSize)!,
                                           color: AppStyle.alertTextColor,
                                           numberOfLines: 2,
                                           minimumScale: 0.8)
    
    private var okButton: UIButton = {
        let okButton = UIButton()
        okButton.titleLabel?.font = UIFont(name: AppStyle.appFontNameBold, size: AppStyle.searchItemLocalTitleFontSize)
        okButton.setTitle("OK", for: .normal)
        okButton.layer.cornerRadius = AppStyle.alertOKButtonCornerRadius
        okButton.backgroundColor = AppStyle.alertViewColor.darker
        return okButton
    }()
    
    func setup() {
        isHidden = true
        backgroundColor = AppStyle.alertViewColor
        setupConstraints()
    }
    
    func setAlertText(_ text: String) {
        alertLabel.text = text
    }
    
    func show(with text: String ) {
        guard isHidden || text != alertLabel.text else { return }
        
        hideIfNeeded {
            self.alertLabel.text = text
            self.show()
        }
    }
    
    func hideIfNeeded(_ completion: (() -> ())? = nil) {
        guard !isHidden else { completion?(); return }
        
        hide(completion)
    }
    
    // MARK: - Private methods
    private func setupConstraints() {
        guard let superview = superview else { return }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        
        heightConstraint = heightAnchor.constraint(equalToConstant: 0.0)
        heightConstraint?.isActive = true
        let stackView = UIStackView().set(axis: .horizontal, spacing: AppStyle.alertViewPadding, alignment: .center)
        stackView.distribution = .fill
        stackView.addArrangedSubview(alertImageView)
        stackView.addArrangedSubview(alertLabel)
        stackView.addArrangedSubview(okButton)
        
        alertImageView.heightAnchor.constraint(equalToConstant: AppStyle.alertImageHeight).isActive = true
        alertImageView.widthAnchor.constraint(equalToConstant: AppStyle.alertImageHeight).isActive = true
        
        okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
        okButton.widthAnchor.constraint(equalToConstant: AppStyle.alertOKButtonWidth).isActive = true
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -AppStyle.alertViewPadding).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: AppStyle.alertViewPadding).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -AppStyle.alertViewPadding).isActive = true
    }
    
    private func show() {
        isHidden = false
        
        UIView.animate(withDuration: AppStyle.animationDuration) {
            self.heightConstraint?.constant = self.alertHeight
            self.superview?.layoutIfNeeded()
        }
    }
    
    private func hide(_ completion: (() -> ())? = nil) {
        guard !isHidden else { return }
        
        UIView.animate(withDuration: AppStyle.animationDuration, animations: {
            self.heightConstraint?.constant = 0
            self.superview?.layoutIfNeeded()
        }, completion: { _ in
            self.isHidden = true
            completion?()
        })
    }
    
    @objc private func okTapped() {
        hide()
    }
}
