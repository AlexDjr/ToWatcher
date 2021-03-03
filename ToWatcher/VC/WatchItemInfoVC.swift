//
//  WatchItemInfoVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 06/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class WatchItemInfoVC: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var localTitle: UILabel = {
        return setupTitle(font: UIFont(name: AppStyle.appFontNameBold, size: AppStyle.watchItemInfoLocalTitleFontSize)!, color: AppStyle.watchItemInfoLabelsTextColor, numberOfLines: 2, minimumScale: 0.8)
    }()
    
    private lazy var originalTitle: UILabel = {
        return setupTitle(font: UIFont(name: AppStyle.appFontNameBold, size: AppStyle.watchItemInfoLabelsFontSize)!, color: AppStyle.watchItemInfoOriginalTitleTextColor, numberOfLines: 2, minimumScale: 0.8)
    }()
    
    private lazy var yearLabel: UILabel = {
        return setupTitle(font: UIFont(name: AppStyle.appFontNameBold, size: AppStyle.watchItemInfoLabelsFontSize)!, color: AppStyle.watchItemInfoLabelsTextColor, numberOfLines: 1, minimumScale: 0.8)
    }()
    
    private lazy var durationLabel: UILabel = {
        return setupTitle(font: UIFont(name: AppStyle.appFontNameBold, size: AppStyle.watchItemInfoLabelsFontSize)!, color: AppStyle.watchItemInfoLabelsTextColor, numberOfLines: 1, minimumScale: 0.8)
    }()
    
    private lazy var genresLabel: UILabel = {
        return setupTitle(font: UIFont(name: AppStyle.appFontNameBold, size: AppStyle.watchItemInfoLabelsFontSize)!, color: AppStyle.watchItemInfoLabelsTextColor, numberOfLines: 2, minimumScale: 0.8)
    }()
    
    private var infoView = UIView()
    private var infoLabelsView = UIView()
    private var scoreView = ScoreView()
    
    private lazy var overviewLabel: UILabel = {
        return setupTitle(font: UIFont(name: AppStyle.appFontNameRegular, size: AppStyle.watchItemInfoLabelsFontSize)!, color: AppStyle.watchItemInfoLabelsTextColor, numberOfLines: 0, minimumScale: 1.0)
    }()
    
    private var watchItem: WatchItem
    
    init(watchItem: WatchItem) {
        self.watchItem = watchItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getMovieInfo(watchItem.id) { result in
            switch result {
            case .success(let movie):
                self.yearLabel.text = movie.year
                self.durationLabel.text = "\(movie.duration)"
                self.genresLabel.text = movie.genres.isEmpty ? "---" : movie.genres.joined(separator: " • ")
                self.overviewLabel.text = movie.overview
                print(">>> genres = \(movie.genres), duration = \(movie.duration)")
                
            case .failure(let error):
                print("ERROR = \(error.localizedDescription)")
            }
        }
        setupView()
    }
    
    // MARK: - Private methods
    private func setupView() {
        view.alpha = 0.0
        
        animateShowView()
        setupWatchItemInfoView()
    }
    
    private func setupWatchItemInfoView() {
        setupScrollView()
        setupLocalTitle()
        setupOriginalTitle()
        setupInfoView()
        setupOverviewLabel()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupLocalTitle() {
        localTitle.text = watchItem.localTitle
        
        scrollView.addSubview(localTitle)
        localTitle.translatesAutoresizingMaskIntoConstraints = false
        localTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: AppStyle.itemHeight + AppStyle.watchItemInfoPadding).isActive = true
        localTitle.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: AppStyle.watchItemInfoPadding).isActive = true
        localTitle.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 2 * AppStyle.watchItemInfoPadding).isActive = true
    }
    
    private func setupOriginalTitle() {
        originalTitle.text = watchItem.originalTitle
        
        scrollView.addSubview(originalTitle)
        originalTitle.translatesAutoresizingMaskIntoConstraints = false
        originalTitle.topAnchor.constraint(equalTo: localTitle.bottomAnchor, constant: AppStyle.watchItemInfoLineSpacing).isActive = true
        originalTitle.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: AppStyle.watchItemInfoPadding).isActive = true
        originalTitle.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 2 * AppStyle.watchItemInfoPadding).isActive = true
    }
    
    private func setupInfoView() {
        scrollView.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.topAnchor.constraint(equalTo: originalTitle.bottomAnchor, constant: AppStyle.watchItemInfoPadding * 2).isActive = true
        infoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        infoView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        
        setupLabels()
        setupScoreView()
    }
    
    private func setupLabels() {
        infoView.addSubview(infoLabelsView)
        infoLabelsView.translatesAutoresizingMaskIntoConstraints = false
        infoLabelsView.topAnchor.constraint(equalTo: infoView.topAnchor).isActive = true
        infoLabelsView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor).isActive = true
        infoLabelsView.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: AppStyle.watchItemInfoPadding * 4 * 2 + 56).isActive = true
        infoLabelsView.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -AppStyle.watchItemInfoPadding).isActive = true
        
        yearLabel.text = ""
        
        infoLabelsView.addSubview(yearLabel)
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.topAnchor.constraint(equalTo: infoLabelsView.topAnchor).isActive = true
        yearLabel.leftAnchor.constraint(equalTo: infoLabelsView.leftAnchor).isActive = true
        yearLabel.rightAnchor.constraint(equalTo: infoLabelsView.rightAnchor).isActive = true
        
        durationLabel.text = ""

        infoLabelsView.addSubview(durationLabel)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: AppStyle.watchItemInfoLineSpacing * 2).isActive = true
        durationLabel.leftAnchor.constraint(equalTo: infoLabelsView.leftAnchor).isActive = true
        durationLabel.rightAnchor.constraint(equalTo: infoLabelsView.rightAnchor).isActive = true
        
        genresLabel.text = ""

        infoLabelsView.addSubview(genresLabel)
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        genresLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: AppStyle.watchItemInfoLineSpacing * 2).isActive = true
        genresLabel.bottomAnchor.constraint(equalTo: infoLabelsView.bottomAnchor).isActive = true
        genresLabel.leftAnchor.constraint(equalTo: infoLabelsView.leftAnchor).isActive = true
        genresLabel.rightAnchor.constraint(equalTo: infoLabelsView.rightAnchor).isActive = true
    }
    
    private func setupScoreView() {
        infoView.addSubview(scoreView)
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        scoreView.heightAnchor.constraint(equalToConstant: 56.0).isActive = true
        scoreView.widthAnchor.constraint(equalToConstant: 56.0).isActive = true
        scoreView.centerYAnchor.constraint(equalTo: infoView.centerYAnchor).isActive = true
        scoreView.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: AppStyle.watchItemInfoPadding * 4).isActive = true
    }
    
    private func setupOverviewLabel() {
        overviewLabel.text = ""
        
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(overviewLabel)
        overviewLabel.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: AppStyle.watchItemInfoPadding * 2).isActive = true
        overviewLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: AppStyle.watchItemInfoPadding).isActive = true
        overviewLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * AppStyle.watchItemInfoPadding).isActive = true
        
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: AppStyle.floatActionButtonHeight + AppStyle.bottomSafeAreaHeight).isActive = true
    }
    
    private func setupTitle(font: UIFont, color: UIColor, numberOfLines: Int, minimumScale: CGFloat) -> UILabel {
        let title = UILabel()
        title.numberOfLines = numberOfLines
        title.font = font
        title.textColor = color
        title.textAlignment = .left
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = minimumScale
        
        return title
    }
    
    private func animateShowView() {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1.0
        }
    }

}
