//
//  SearchItemCell.swift
//  ToWatcher
//
//  Created by Alex Delin on 17.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

class SearchItemCell: UICollectionViewCell {
    static let reuseIdentifier = "searchItemCell"
    
    private lazy var mainView = WatchItemMainView()
    private var localTitleLabel = UILabel()
    private var originalTitleLabel = UILabel()
    private var yearLabel = UILabel()
    
    var watchItem: WatchItem? {
        didSet {
            guard let watchItem = watchItem else { return }
            mainView.setImage(watchItem.image)
            localTitleLabel.text = watchItem.localTitle
            originalTitleLabel.text = watchItem.originalTitle
            yearLabel.text = watchItem.year
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private methods
    private func setupView() {
        setupMainView()
        setupLocalTitleLabel()
        setupOriginalTitleLabel()
        setupYearLabel()
    }
    
    private func setupMainView() {
        contentView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        mainView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        mainView.rightAnchor.constraint(equalTo: contentView.leftAnchor, constant: AppStyle.searchItemMainViewWidth).isActive = true
    }
    
    private func setupLocalTitleLabel() {
        localTitleLabel.numberOfLines = 2
        localTitleLabel.textColor = AppStyle.menuItemActiveTextColor
        localTitleLabel.font = UIFont(name: AppStyle.appFontNameBold, size: AppStyle.searchItemLocalTitleFontSize)!
        
        contentView.addSubview(localTitleLabel)
        localTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        localTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.0).isActive = true
        localTitleLabel.leftAnchor.constraint(equalTo: mainView.rightAnchor, constant: AppStyle.itemsLineSpacing).isActive = true
        localTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    private func setupOriginalTitleLabel() {
        originalTitleLabel.numberOfLines = 1
        originalTitleLabel.textColor = AppStyle.menuItemInactiveTextColor
        originalTitleLabel.font = UIFont(name: AppStyle.appFontNameSemiBold, size: AppStyle.searchItemOriginalTitleFontSize)!
        
        contentView.addSubview(originalTitleLabel)
        originalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        originalTitleLabel.topAnchor.constraint(equalTo: localTitleLabel.bottomAnchor, constant: 2.0).isActive = true
        originalTitleLabel.leftAnchor.constraint(equalTo: mainView.rightAnchor, constant: AppStyle.itemsLineSpacing).isActive = true
        originalTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    private func setupYearLabel() {
        yearLabel.numberOfLines = 1
        yearLabel.textColor = AppStyle.menuItemActiveTextColor
        yearLabel.font = UIFont(name: AppStyle.appFontNameSemiBold, size: AppStyle.searchItemYearFontSize)!
        
        contentView.addSubview(yearLabel)
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 2.0).isActive = true
        yearLabel.leftAnchor.constraint(equalTo: mainView.rightAnchor, constant: AppStyle.itemsLineSpacing).isActive = true
        yearLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
}