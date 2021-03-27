//
//  WatchItemInfoVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 06/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class WatchItemInfoVC: UIViewController {
    private var scrollView = UIScrollView.standart()
    
    private var localTitle = UILabel().set(font: UIFont(name: AppStyle.appFontNameBold, size: AppStyle.watchItemInfoLocalTitleFontSize)!,
                                                color: AppStyle.watchItemInfoLabelsTextColor,
                                                numberOfLines: 2,
                                                minimumScale: 0.8)
    
    private var originalTitle = UILabel().set(font: UIFont(name: AppStyle.appFontNameBold, size: AppStyle.watchItemInfoLabelsFontSize)!,
                                                   color: AppStyle.watchItemInfoOriginalTitleTextColor,
                                                   numberOfLines: 2,
                                                   minimumScale: 0.8)
    
    private var titlesStackView = UIStackView().set(axis: .vertical, spacing: AppStyle.watchItemInfoLineSpacing, alignment: .leading)
    
    private var yearLabel = UILabel().set(font: UIFont(name: AppStyle.appFontNameBold, size: AppStyle.watchItemInfoLabelsFontSize)!,
                                               color: AppStyle.watchItemInfoLabelsTextColor,
                                               numberOfLines: 1,
                                               minimumScale: 0.8)
    
    private var durationLabel = UILabel().set(font: UIFont(name: AppStyle.appFontNameBold, size: AppStyle.watchItemInfoLabelsFontSize)!,
                                                   color: AppStyle.watchItemInfoLabelsTextColor,
                                                   numberOfLines: 1,
                                                   minimumScale: 0.8)
    
    private var genresLabel = UILabel().set(font: UIFont(name: AppStyle.appFontNameBold, size: AppStyle.watchItemInfoLabelsFontSize)!,
                                                 color: AppStyle.watchItemInfoLabelsTextColor,
                                                 numberOfLines: 2,
                                                 minimumScale: 0.8)
    
    private var infoView = UIView()
    private var infoLabelsView = UIView()
    private var scoreView = ScoreView(.big)
    
    private var overviewLabel = UILabel().set(font: UIFont(name: AppStyle.appFontNameRegular, size: AppStyle.watchItemInfoLabelsFontSize)!,
                                                   color: AppStyle.watchItemInfoLabelsTextColor,
                                                   numberOfLines: 0,
                                                   minimumScale: 1.0)
    
    private var castScrollView = UIScrollView.standart()
    private var directorView = PersonView()
    private var actorsViews = [PersonView]()
    
    private var watchItem: WatchItem
    
    init(watchItem: WatchItem) {
        self.watchItem = watchItem
        super.init(nibName: nil, bundle: nil)
        getMovieInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private methods
    private func getMovieInfo() {
        guard !watchItem.isMovieInfoAdded else { return }
        
        NetworkManager.shared.getMovieInfo(watchItem.id) { result in
            switch result {
            case .success(let movie):
                self.watchItem.addMovieInfo(movie)
                self.setupMovieInfo()
                DBManager.shared.update(self.watchItem)
                
            case .failure(let error):
                print("ERROR = \(error.localizedDescription)")
            }
        }
    }
    
    private func setupMovieInfo() {
        guard watchItem.isMovieInfoAdded else { return }
        infoView.isHidden = false
        
        yearLabel.text = watchItem.year
        durationLabel.text = "\(watchItem.duration)"
        genresLabel.text = watchItem.genresString
        overviewLabel.text = watchItem.overview
        
        if let director = watchItem.director {
            directorView = PersonView(director)
        }
        
        if actorsViews.count == 0 {
            watchItem.cast.forEach { actor in
                let personView = PersonView(actor)
                actorsViews.append(personView)
            }
        }
        
        if isViewLoaded {
            setupDirectorView()
            setupActorsView()
        }
    }

    private func setupView() {
        view.alpha = 0.0
        
        animateShowView()
        setupWatchItemInfoView()
    }
    
    private func setupWatchItemInfoView() {
        setupScrollView()
        setupTitles()
        setupInfoView()
        setupOverviewLabel()
        setupCastScrollView()
        setupMovieInfo()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupTitles() {
        originalTitle.isHidden = watchItem.localTitle == watchItem.originalTitle
        localTitle.text = watchItem.localTitle
        originalTitle.text = watchItem.originalTitle
        
        titlesStackView.addArrangedSubview(localTitle)
        titlesStackView.addArrangedSubview(originalTitle)
        
        scrollView.addSubview(titlesStackView)
        titlesStackView.translatesAutoresizingMaskIntoConstraints = false
        titlesStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: AppStyle.itemHeight + AppStyle.watchItemInfoPadding).isActive = true
        titlesStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: AppStyle.watchItemInfoPadding).isActive = true
        titlesStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * AppStyle.watchItemInfoPadding).isActive = true
    }
    
    private func setupInfoView() {
        infoView.isHidden = true
        
        scrollView.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.topAnchor.constraint(equalTo: titlesStackView.bottomAnchor, constant: AppStyle.watchItemInfoPadding * 2).isActive = true
        infoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        infoView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        
        setupScoreView()
        setupLabels()
    }
    
    private func setupScoreView() {
        scoreView.score = watchItem.score
        
        infoView.addSubview(scoreView)
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        scoreView.heightAnchor.constraint(equalToConstant: scoreView.viewHeight).isActive = true
        scoreView.widthAnchor.constraint(equalToConstant: scoreView.viewHeight).isActive = true
        scoreView.centerYAnchor.constraint(equalTo: infoView.centerYAnchor).isActive = true
        scoreView.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: AppStyle.watchItemInfoPadding * 4).isActive = true
    }
    
    private func setupLabels() {
        infoView.addSubview(infoLabelsView)
        infoLabelsView.translatesAutoresizingMaskIntoConstraints = false
        infoLabelsView.topAnchor.constraint(equalTo: infoView.topAnchor).isActive = true
        infoLabelsView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor).isActive = true
        infoLabelsView.leftAnchor.constraint(equalTo: scoreView.rightAnchor, constant: AppStyle.watchItemInfoPadding * 4).isActive = true
        infoLabelsView.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -AppStyle.watchItemInfoPadding).isActive = true
        
        infoLabelsView.addSubview(yearLabel)
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.topAnchor.constraint(equalTo: infoLabelsView.topAnchor).isActive = true
        yearLabel.leftAnchor.constraint(equalTo: infoLabelsView.leftAnchor).isActive = true
        yearLabel.rightAnchor.constraint(equalTo: infoLabelsView.rightAnchor).isActive = true

        infoLabelsView.addSubview(durationLabel)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: AppStyle.watchItemInfoLineSpacing * 2).isActive = true
        durationLabel.leftAnchor.constraint(equalTo: infoLabelsView.leftAnchor).isActive = true
        durationLabel.rightAnchor.constraint(equalTo: infoLabelsView.rightAnchor).isActive = true

        infoLabelsView.addSubview(genresLabel)
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        genresLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: AppStyle.watchItemInfoLineSpacing * 2).isActive = true
        genresLabel.bottomAnchor.constraint(equalTo: infoLabelsView.bottomAnchor).isActive = true
        genresLabel.leftAnchor.constraint(equalTo: infoLabelsView.leftAnchor).isActive = true
        genresLabel.rightAnchor.constraint(equalTo: infoLabelsView.rightAnchor).isActive = true
    }
    
    private func setupOverviewLabel() {
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(overviewLabel)
        overviewLabel.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: AppStyle.watchItemInfoPadding * 2).isActive = true
        overviewLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: AppStyle.watchItemInfoPadding).isActive = true
        overviewLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * AppStyle.watchItemInfoPadding).isActive = true
    }
    
    private func setupCastScrollView() {
        castScrollView.contentInset = UIEdgeInsets(top: 0.0, left: AppStyle.watchItemInfoPadding, bottom: 0.0, right: AppStyle.watchItemInfoPadding)
        
        scrollView.addSubview(castScrollView)
        castScrollView.translatesAutoresizingMaskIntoConstraints = false
        castScrollView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: AppStyle.watchItemInfoPadding * 2).isActive = true
        castScrollView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        castScrollView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: castScrollView.bottomAnchor, constant: AppStyle.floatActionButtonHeight + AppStyle.floatActionButtonPadding * 2).isActive = true
    }
    
    private func setupDirectorView() {
        guard directorView.person != nil else { return }
        
        let directorTitleLabel = castTitleLabel()
        directorTitleLabel.text = "Режиссер"
        
        let directorStackView = UIStackView().set(axis: .vertical, spacing: 4.0, alignment: .center)
        directorStackView.addArrangedSubview(directorTitleLabel)
        directorStackView.addArrangedSubview(directorView)
        
        castScrollView.addSubview(directorStackView)
        directorStackView.translatesAutoresizingMaskIntoConstraints = false
        directorStackView.topAnchor.constraint(equalTo: castScrollView.topAnchor).isActive = true
        directorStackView.heightAnchor.constraint(lessThanOrEqualTo: castScrollView.heightAnchor).isActive = true
        directorStackView.leftAnchor.constraint(equalTo: castScrollView.leftAnchor).isActive = true
        directorStackView.widthAnchor.constraint(equalToConstant: AppStyle.directorViewWidth).isActive = true
    }
    
    private func setupActorsView() {
        guard !actorsViews.isEmpty else { return }
        
        let actorsHStackView = UIStackView().set(axis: .horizontal, spacing: 2.0, alignment: .top)
        
        for view in actorsViews {
            view.widthAnchor.constraint(equalToConstant: AppStyle.actorViewWidth).isActive = true
            actorsHStackView.addArrangedSubview(view)
        }
        
        let actorsTitleLabel = castTitleLabel()
        actorsTitleLabel.text = "Актеры"
        
        let view = UIView()
        view.addSubview(actorsTitleLabel)
        actorsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        actorsTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        actorsTitleLabel.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        view.widthAnchor.constraint(equalToConstant: AppStyle.actorViewWidth).isActive = true
        
        let actorsVStackView = UIStackView().set(axis: .vertical, spacing: 4.0, alignment: .leading)
        actorsVStackView.addArrangedSubview(view)
        actorsVStackView.addArrangedSubview(actorsHStackView)
        
        castScrollView.addSubview(actorsVStackView)
        actorsVStackView.translatesAutoresizingMaskIntoConstraints = false
        actorsVStackView.topAnchor.constraint(equalTo: castScrollView.topAnchor).isActive = true
        actorsVStackView.heightAnchor.constraint(lessThanOrEqualTo: castScrollView.heightAnchor).isActive = true
        actorsVStackView.leftAnchor.constraint(equalTo: castScrollView.leftAnchor, constant: AppStyle.directorViewWidth + AppStyle.watchItemInfoPadding * 3).isActive = true
        
        castScrollView.contentLayoutGuide.rightAnchor.constraint(equalTo: actorsVStackView.rightAnchor).isActive = true
    }
    
    private func castTitleLabel() -> UILabel {
        return UILabel().set(font: UIFont(name: AppStyle.appFontNameBold, size: AppStyle.watchItemInfoLabelsFontSize)!,
                            color: AppStyle.watchItemInfoLabelsTextColor,
                            numberOfLines: 1,
                            minimumScale: 1.0,
                            alignment: .center)
    }
    
    private func animateShowView() {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1.0
        }
    }

}
