//
//  WatchItemInfoVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 06/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class WatchItemInfoVC: UIViewController {
    lazy var localTitle: UILabel = {
        return setupTitle(withFontSize: AppStyle.watchItemInfoLocalTitleFontSize, andColor: AppStyle.watchItemInfoLocalTitleTextColor)
    }()
    
    lazy var originalTitle: UILabel = {
        return setupTitle(withFontSize: AppStyle.watchItemInfoOriginalTitleFontSize, andColor: AppStyle.watchItemInfoOriginalTitleTextColor)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
//        self.view.backgroundColor = .purple
        view.alpha = 0.0
        
        animateShowView()
        setupWatchItemInfoView()
    }
    
    
    private func setupWatchItemInfoView() {
        setupLocalTitleView()
        setupOriginalTitleView()
    }
    
    private func setupLocalTitleView() {
        localTitle.text = "Как трусливый Роберт Форд убил Джесси Джеймса"
        
        view.addSubview(localTitle)
        localTitle.translatesAutoresizingMaskIntoConstraints = false
        localTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: AppStyle.watchItemInfoPadding).isActive = true
        localTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: AppStyle.watchItemInfoPadding).isActive = true
        localTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -AppStyle.watchItemInfoPadding).isActive = true
    }
    
    private func setupOriginalTitleView() {
        originalTitle.text = "The Assassination of Jesse James by the coward Robert Ford"
        
        view.addSubview(originalTitle)
        originalTitle.translatesAutoresizingMaskIntoConstraints = false
        originalTitle.topAnchor.constraint(equalTo: localTitle.bottomAnchor, constant: AppStyle.watchItemInfoLineSpacing).isActive = true
        originalTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: AppStyle.watchItemInfoPadding).isActive = true
        originalTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -AppStyle.watchItemInfoPadding).isActive = true
    }
    
    private func setupTitle(withFontSize fontSize: CGFloat, andColor color: UIColor) -> UILabel {
        let title = UILabel()
        title.numberOfLines = 2
        title.font = UIFont(name: AppStyle.appFontNameBold, size: fontSize)
        title.textColor = color
        title.textAlignment = .left
        title.adjustsFontSizeToFitWidth = true;
        title.minimumScaleFactor = 0.8;
        
        return title
    }
    
    private func animateShowView() {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1.0
        }
    }

}
