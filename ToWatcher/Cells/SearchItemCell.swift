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
    
    private var mainView = WatchItemMainView()
    
    private var localTitleLabel = UILabel().set(font: UIFont(name: AppStyle.appFontNameBold, size: AppStyle.searchItemLocalTitleFontSize)!,
                                                color: AppStyle.menuItemActiveTextColor,
                                                numberOfLines: 2)
    
    private var originalTitleLabel = UILabel().set(font: UIFont(name: AppStyle.appFontNameSemiBold, size: AppStyle.searchItemOriginalTitleFontSize)!,
                                                   color: AppStyle.menuItemInactiveTextColor,
                                                   numberOfLines: 1)
    
    private var yearLabel = UILabel().set(font: UIFont(name: AppStyle.appFontNameSemiBold, size: AppStyle.searchItemYearFontSize)!,
                                          color: AppStyle.menuItemActiveTextColor,
                                          numberOfLines: 1)
    
    private var scoreView = ScoreView(.small)
    
    var watchItem: WatchItem? {
        didSet {
            guard let watchItem = watchItem else { return }
            mainView.setImage(watchItem.backdropURL)
            localTitleLabel.text = watchItem.localTitle
            originalTitleLabel.text = watchItem.localTitle == watchItem.originalTitle ? "" : watchItem.originalTitle
            yearLabel.text = watchItem.year
            scoreView.score = watchItem.score
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public methods
    func getAnimationTransform(with currentY: CGFloat) -> CGAffineTransform {
        let scaleY = AppStyle.itemHeight / mainView.frame.height
        let scaleX = AppStyle.screenWidth / mainView.frame.width
        let transformScaled = CGAffineTransform(scaleX: scaleX, y: scaleY)
        
        let transformedWidth = self.frame.size.applying(transformScaled).width
        let deltaX = (transformedWidth - AppStyle.screenWidth) / (2 * scaleX)
        let xScaledTransform = transformScaled.translatedBy(x: deltaX, y: 0)
         
        let halfHeightDeltaAfterScale = (AppStyle.itemHeight - frame.height) / 2
        let delta = currentY - (AppStyle.menuBarFullHeight) - halfHeightDeltaAfterScale
        let yXScaledTransform = xScaledTransform.translatedBy(x: 0, y: -delta / scaleY)
        
        // TODO: Сейчас после увеличении ячейки на экране поиска ее тень выглядит не так, как у ячеек на WatchItemsVC.
        
        return yXScaledTransform
    }
    
    func hideInfo() {
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
                        self.localTitleLabel.alpha = 0.0
                        self.originalTitleLabel.alpha = 0.0
                        self.yearLabel.alpha = 0.0
                        self.scoreView.alpha = 0.0
                       })
    }
    
    // MARK: - Private methods
    private func setupView() {
        setupMainView()
        setupStackView()
    }
    
    private func setupMainView() {
        contentView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        mainView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        mainView.rightAnchor.constraint(equalTo: contentView.leftAnchor, constant: AppStyle.searchItemMainViewWidth).isActive = true
    }
    
    private func setupStackView() {
        var spacing: CGFloat = 0.0
        var customSpacing: CGFloat = 0.0
        
        switch UIDevice.current.screenType {
        case .iPhones_320:
            spacing = 1.0
            customSpacing = 1.0
        case .iPhones_375:
            spacing = 2.0
            customSpacing = 1.0
        case .iPhone_414:
            spacing = 4.0
            customSpacing = 2.0
        }
        
        let horizontalStackView = UIStackView().set(axis: .horizontal, spacing: AppStyle.itemsLineSpacing, alignment: .center)
        
        horizontalStackView.addArrangedSubview(scoreView)
        horizontalStackView.addArrangedSubview(yearLabel)
        
        let stackView = UIStackView().set(axis: .vertical, spacing: spacing, alignment: .leading)
        
        stackView.addArrangedSubview(localTitleLabel)
        stackView.setCustomSpacing(customSpacing, after: localTitleLabel)
        stackView.addArrangedSubview(originalTitleLabel)
        stackView.addArrangedSubview(horizontalStackView)
        
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -2.0).isActive = true
        stackView.leftAnchor.constraint(equalTo: mainView.rightAnchor, constant: AppStyle.itemsLineSpacing).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
}
