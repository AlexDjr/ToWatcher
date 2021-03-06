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
    enum Size {
        case big
        case small
    }
    
    var score: Double? {
        didSet {
            setupScore()
        }
    }
    
    var viewHeight: CGFloat = 0.0
    
    private var size: Size = .big
    private var ringWidth: CGFloat = 0.0
    private var fontSize: CGFloat = 0.0
    
    private var scoreLabel = UILabel()
    private var ringProgressView = RingProgressView()
    
    convenience init(_ size: Size) {
        self.init(frame: CGRect.zero)
        self.size = size
        
        setupSize()
        setupScoreLabel()
        setupRingProgressView()
        self.backgroundColor = AppStyle.mainBGColor
        self.layer.cornerRadius = viewHeight / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private methods
    private func setupSize() {
        switch size {
        case .big:
            viewHeight = AppStyle.bigScoreViewHeight
            ringWidth = 4.0
            fontSize = AppStyle.bigScoreViewFontSize
        case .small:
            viewHeight = AppStyle.smallScoreViewHeight
            ringWidth = 2.0
            fontSize = AppStyle.smallScoreViewFontSize
        }
    }
    
    private func setupScoreLabel() {
        scoreLabel.font = UIFont(name: AppStyle.appFontNameBold, size: fontSize)
        scoreLabel.textColor = AppStyle.menuItemActiveTextColor
        
        self.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        scoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupRingProgressView() {
        ringProgressView = RingProgressView(frame: CGRect(x: 0, y: 0, width: viewHeight, height: viewHeight))
        ringProgressView.backgroundRingColor = AppStyle.scoreBGColor
        ringProgressView.shadowOpacity = 0.0
        ringProgressView.ringWidth = ringWidth
        
        self.addSubview(ringProgressView)
        ringProgressView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        ringProgressView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        ringProgressView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        ringProgressView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func setupScore() {
        setupScoreColor()
        setupScoreValue()
    }
    
    private func setupScoreColor() {
        var color = UIColor.clear
        
        guard let score = score else {
            ringProgressView.progress = 0.0
            ringProgressView.startColor = color
            ringProgressView.endColor = color
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
    }
    
    private func setupScoreValue() {
        guard let score = score else {
            ringProgressView.progress = 0.0
            scoreLabel.text = "0.0"
            return
        }
        
        ringProgressView.progress = score / 10
        scoreLabel.text = "\(score)"
    }
}
