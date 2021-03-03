//
//  ScoreView.swift
//  ToWatcher
//
//  Created by Alex Delin on 15.02.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import UIKit
import MKRingProgressView

class ScoreView: UIView {
    var score: Double? {
        didSet {
            setupScore(score)
        }
    }
    
    private var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppStyle.appFontNameBold, size: 18.0)
        label.textColor = AppStyle.menuItemActiveTextColor
        return label
    }()
    
    private var ringProgressView: RingProgressView = {
        let ringProgressView = RingProgressView(frame: CGRect(x: 0, y: 0, width: AppStyle.scoreViewHeight, height: AppStyle.scoreViewHeight))
        ringProgressView.backgroundRingColor = AppStyle.scoreBGColor
        ringProgressView.shadowOpacity = 0.0
        ringProgressView.ringWidth = 4
        return ringProgressView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = AppStyle.mainBGColor
        self.layer.cornerRadius = AppStyle.scoreViewHeight / 2
        
        self.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        scoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        self.addSubview(ringProgressView)
        ringProgressView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        ringProgressView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        ringProgressView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        ringProgressView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private methods
    private func setupScore(_ score: Double?) {
        var color = UIColor.clear
        
        guard let score = score else {
            ringProgressView.progress = 0.0
            ringProgressView.startColor = color
            ringProgressView.endColor = color
            scoreLabel.text = "0.0"
            return
        }
        
        if score == 0.0 {
            color = UIColor.clear
        } else if score < 4.0 {
            color = AppStyle.scoreLowColor
        } else if score < 7.0 {
            color = AppStyle.scoreMiddleColor
        } else {
            color = AppStyle.scoreHighColor
        }
        
        ringProgressView.startColor = color
        ringProgressView.endColor = color
        
        ringProgressView.progress = score / 10
        scoreLabel.text = "\(score)"
    }
}
