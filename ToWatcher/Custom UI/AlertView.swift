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
    
    private var alertImageView = UIImageView()
    private var alertLabel = UILabel().set(font: UIFont(name: AppStyle.appFontNameSemiBold, size: AppStyle.searchItemLocalTitleFontSize)!,
                                           color: AppStyle.alertViewTextColor,
                                           numberOfLines: 2,
                                           minimumScale: 0.8)
    
    private var style: AlertStyle = .error {
        didSet {
            switch style {
            case .error:
                backgroundColor = AppStyle.alertViewErrorColor
                alertImageView.image = AppStyle.alertViewErrorImage
            case .warning:
                backgroundColor = AppStyle.alertViewWarningColor
                alertImageView.image = AppStyle.alertViewWarningImage
            }
        }
    }
    
    enum AlertStyle {
        case error
        case warning
    }
    
    private var autoHidingTimer: Timer?
    private var fromIndexPath: IndexPath?
    
    func setup() {
        isHidden = true
        setupConstraints()
    }
    
    func show(text: String, style: AlertStyle, from: IndexPath? = nil) {
        let isClosingNow = isAnimating && !isHidden
        if isClosingNow {
            // TODO: В идеале дождаться точного окончания анимации и тогда вызывать
            DispatchQueue.main.asyncAfter(deadline: .now() + AppStyle.animationDuration) { self.show(text: text, style: style, from: from) }
            return
        }
        
        let isSameErrorAlreadyShown = style == .error && text == alertLabel.text && !isHidden
        let isSameWarningAlreadyShown = style == .warning && from == fromIndexPath && !isHidden
        guard !(isSameErrorAlreadyShown || isSameWarningAlreadyShown) else { return }
        
        autoHidingTimer?.invalidate()
        
        hideIfNeeded {
            self.alertLabel.text = text
            self.style = style
            self.fromIndexPath = from
            
            self.setAutoHidingTimer()
            
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
        
        alertImageView.heightAnchor.constraint(equalToConstant: AppStyle.alertImageHeight).isActive = true
        alertImageView.widthAnchor.constraint(equalToConstant: AppStyle.alertImageHeight).isActive = true
        
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
    
    private func setAutoHidingTimer() {
        self.autoHidingTimer = Timer.scheduledTimer(withTimeInterval: AppStyle.alertViewAutoHidingInterval, repeats: false) { _ in
            self.hideIfNeeded()
        }
    }
}
