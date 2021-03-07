//
//  WatchItemView.swift
//  SwipeTest
//
//  Created by Alex Delin on 02.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

class WatchItemView: UIView {
    var currentEditState: WatchItemEditState = .default {
        didSet { setupCellState() }
    }
    
    private weak var contextCell: WatchItemCell?
    
    var itemRemovedCallback: (() -> ())? {
        didSet {
            watchedView.itemDeletedCallback = itemRemovedCallback
            deleteView.itemDeletedCallback = itemRemovedCallback
        }
    }
    
    lazy var mainView = WatchItemMainView()
    lazy var deleteView = WatchItemActionView(.delete)
    lazy var watchedView = WatchItemActionView(.watched)
    
    private var originalTitleLabel: UILabel = {
        let originalTitleLabel = UILabel()
        originalTitleLabel.numberOfLines = 2
        originalTitleLabel.font = UIFont(name: AppStyle.appFontNameSemiBold, size: AppStyle.watchItemOriginalTitleFontSize)!
        originalTitleLabel.textColor = AppStyle.mainBGColor
        originalTitleLabel.addShadow(radius: 2.0)
        return originalTitleLabel
    }()
    
    private var localTitleLabel: UILabel = {
        let localTitleLabel = UILabel()
        localTitleLabel.numberOfLines = 2
        localTitleLabel.sizeToFit()
        localTitleLabel.font = UIFont(name: AppStyle.appFontNameBold, size: AppStyle.watchItemLocalTitleFontSize)!
        localTitleLabel.textColor = AppStyle.mainBGColor
        localTitleLabel.addShadow(radius: 3.0)
        return localTitleLabel
    }()
    
    private var yearLabel: UILabel = {
        let yearLabel = UILabel()
        yearLabel.numberOfLines = 1
        yearLabel.font = UIFont(name: AppStyle.appFontNameSemiBold, size: AppStyle.watchItemYearFontSize)!
        yearLabel.textColor = AppStyle.mainBGColor
        yearLabel.addShadow(radius: 2.0)
        return yearLabel
    }()
    
    private var scoreView = ScoreView(.big)
    
    private var gestureRecognizer = UIPanGestureRecognizer()
    private let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
    
    private var activeActionView = UIView()
    
    private var leftMainConstraint: NSLayoutConstraint!
    private var rightMainConstraint: NSLayoutConstraint!
    private var watchedConstraint: NSLayoutConstraint!
    private var deleteConstraint: NSLayoutConstraint!
    
    private var isRemoving = false
    
    convenience init(_ contextCell: WatchItemCell) {
        self.init()
        self.contextCell = contextCell
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public methods
    func setWatchItemInfo(_ watchItem: WatchItem) {
        mainView.setImage(watchItem.imageURL)
        
        originalTitleLabel.isHidden = watchItem.localTitle == watchItem.originalTitle
        
        originalTitleLabel.text = watchItem.originalTitle
        localTitleLabel.text = watchItem.localTitle
        yearLabel.text = watchItem.year
        scoreView.score = watchItem.score
    }
    
    func setupState(_ state: WatchItemCellState = .enabled) {
        guard !isRemoving else {
            isRemoving = false;
            gestureRecognizer.isEnabled = false
            return
        }
        
        mainView.setupState(state)
        switch state {
        case .editing:
            gestureRecognizer.isEnabled = true
        case .enabled:
            UIView.animate(withDuration: AppStyle.animationDuration) { self.scoreView.alpha = 1.0 }
            gestureRecognizer.isEnabled = false
            
            if currentEditState != .default {
                moveViewToEndState(.default, duration: AppStyle.animationDuration)
            }
        case .disabled:
            UIView.animate(withDuration: AppStyle.animationDuration) { self.scoreView.alpha = 0.0 }
            gestureRecognizer.isEnabled = false
        }
    }
    
    func hideInfo() {
        UIView.animate(withDuration: AppStyle.animationDuration, delay: 0.4, options: [],
                       animations: {
                        self.originalTitleLabel.alpha = 0.0
                        self.localTitleLabel.alpha = 0.0
                        self.yearLabel.alpha = 0.0
                        self.scoreView.alpha = 0.0
                       },
                       completion: nil)
    }
    
    func showInfo() {
        UIView.animate(withDuration: AppStyle.animationDuration, delay: 0.2, options: [],
                       animations: {
                        self.originalTitleLabel.alpha = 1.0
                        self.localTitleLabel.alpha = 1.0
                        self.yearLabel.alpha = 1.0
                        self.scoreView.alpha = 1.0
                       },
                       completion: nil)
    }
    
    // MARK: - Private methods
    private func setupView() {
        addMainView()
        addStackView()
        setupScoreView()
        addDeleteView()
        addWatchedView()
        setupActionViewActiveConstraints()
        
        itemRemovedCallback = { [weak self] in
            self?.animateRemoving() { _ in
                guard let self = self, let cell = self.contextCell, let watchItem = cell.watchItem else { return }
                cell.delegate?.didRemoveItem(watchItem, withType: self.currentEditState)
            }
        }
        
        addGestureRecognizer()
    }
    
    private func addGestureRecognizer() {
        gestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.isEnabled = false
    }
    
    private func addMainView() {
        self.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        leftMainConstraint = mainView.leftAnchor.constraint(equalTo: self.leftAnchor)
        leftMainConstraint.isActive = true
        rightMainConstraint = mainView.rightAnchor.constraint(equalTo: self.rightAnchor)
        rightMainConstraint.isActive = true
    }
    
    private func addStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0.0
        stackView.alignment = .leading
        
        stackView.addArrangedSubview(originalTitleLabel)
        stackView.addArrangedSubview(localTitleLabel)
        stackView.setCustomSpacing(10.0, after: localTitleLabel)
        stackView.addArrangedSubview(yearLabel)
        
        mainView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: AppStyle.watchItemLabelsPadding).isActive = true
        stackView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: AppStyle.watchItemLabelsPadding).isActive = true
        stackView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -AppStyle.watchItemOriginalTitleRightPadding).isActive = true
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor, constant: -AppStyle.watchItemYearBottomPadding).isActive = true
    }
    
    private func setupScoreView() {
        mainView.addSubview(scoreView)
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        scoreView.heightAnchor.constraint(equalToConstant: scoreView.viewHeight).isActive = true
        scoreView.widthAnchor.constraint(equalToConstant: scoreView.viewHeight).isActive = true
        scoreView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -14).isActive = true
        scoreView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -14).isActive = true
    }
    
    private func addWatchedView() {
        self.insertSubview(watchedView, belowSubview: mainView)
        watchedView.translatesAutoresizingMaskIntoConstraints = false
        watchedView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        watchedView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        watchedView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        
        watchedConstraint = watchedView.rightAnchor.constraint(equalTo: self.centerXAnchor)
        watchedConstraint.isActive = true
    }
    
    private func addDeleteView() {
        self.insertSubview(deleteView, belowSubview: mainView)
        deleteView.translatesAutoresizingMaskIntoConstraints = false
        deleteView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        deleteView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        deleteView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        deleteConstraint = deleteView.leftAnchor.constraint(equalTo: self.centerXAnchor)
        deleteConstraint.isActive = true
    }
    
    private func setupActionViewActiveConstraints() {
        watchedView.activeConstraint = watchedView.actionView.rightAnchor.constraint(equalTo: mainView.leftAnchor)
        deleteView.activeConstraint = deleteView.actionView.leftAnchor.constraint(equalTo: mainView.rightAnchor)
    }
    
    private func setupCellState() {
        switch currentEditState {
        case .toWatched:
            activeActionView = watchedView
            watchedView.isHidden = false
            deleteView.isHidden = true
        case .toDelete:
            activeActionView = deleteView
            watchedView.isHidden = true
            deleteView.isHidden = false
        default: break
        }
    }
    
    // MARK: - Pan gesture methods
    @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began {
            handleBeganState()
        } else if gestureRecognizer.state == .changed {
            handleChangeState()
        } else if gestureRecognizer.state == .ended {
            handleEndState()
        }
    }
    
    // MARK: - Pan gesture 'Begin' state
    private func handleBeganState() {
        guard currentEditState == .default else { return }
        changeCellState()
        activeActionView.alpha = 0.0
    }
    
    private func changeCellState() {
        switch gestureRecognizer.direction {
        case .right: currentEditState = .toWatched
        case .left: currentEditState = .toDelete
        }
    }
    
    // MARK: - Pan gesture 'Change' state
    private func handleChangeState() {
        let translationPoint = gestureRecognizer.translation(in: self)
        
        let currentXPoint = leftMainConstraint.constant
        let newXPoint = getXPoint(from: translationPoint)
        
        let shouldViewStickToFrame = currentXPoint == 0.0 && abs(newXPoint) < AppStyle.watchItemEditStickToFrameGap
        guard !shouldViewStickToFrame else { return }
        
        //        let canMoveView = abs(newXPoint) <= AppStyle.watchItemEditActionViewWidth && newXPoint != currentXPoint
        //        guard canMoveView else { return }
        
        switchCellStateIfNeeded(current: currentXPoint, new: newXPoint)
        
        let shouldStop = (contextCell as? WatchedItemCell) != nil && abs(newXPoint) > AppStyle.watchItemEditWatchedShouldStopGap && currentEditState == .toWatched
        guard !shouldStop else { return }
        
        moveMainView(newXPoint)
        showActionView(for: newXPoint)
        gestureRecognizer.setTranslation(.zero, in: self)
    }
    
    private func getXPoint(from translationPoint: CGPoint) -> CGFloat {
        var xPoint = leftMainConstraint.constant + translationPoint.x
        
        //        let isMaxWidthReached = abs(leadingConstraint.constant) < AppStyle.watchItemEditActionViewWidth && abs(xPoint) > AppStyle.watchItemEditActionViewWidth
        //        if isMaxWidthReached {
        //            xPoint = xPoint > 0 ? AppStyle.watchItemEditActionViewWidth : -AppStyle.watchItemEditActionViewWidth
        //        }
        
        let shouldStickToFrame = abs(xPoint) < AppStyle.watchItemEditStickToFrameGap
        if shouldStickToFrame {
            xPoint = 0.0
        }
        
        return xPoint
    }
    
    private func switchCellStateIfNeeded(current currentXPoint: CGFloat, new newXPoint: CGFloat) {
        if newXPoint == 0.0 && currentXPoint != 0.0 && currentEditState != .default {
            impactFeedbackgenerator.impactOccurred()
            currentEditState = .default
        } else if currentXPoint >= 0.0 && newXPoint < 0.0 && currentEditState != .toDelete {
            currentEditState = .toDelete
        } else if currentXPoint <= 0.0 && newXPoint > 0.0 && currentEditState != .toWatched {
            currentEditState = .toWatched
        }
    }
    
    private func moveMainView(_ newConstant: CGFloat) {
        UIView.animate(withDuration: 0.01) {
            self.changeConstraints(newConstant, isForAnimation: true)
            //            if abs(newConstant) == AppStyle.watchItemEditActionViewWidth {
            //                self.impactFeedbackgenerator.impactOccurred()
            //            }
        }
        
        moveActionViewIfNeeded(newConstant)
    }
    
    private func moveActionViewIfNeeded(_ newConstant: CGFloat) {
        if newConstant >= 0.0 {
            changeConstraints(of: watchedView, with: newConstant)
            UIView.animate(withDuration: 0.2) {
                self.watchedView.layoutIfNeeded()
            }
        } else {
            changeConstraints(of: deleteView, with: newConstant)
            UIView.animate(withDuration: 0.2) {
                self.deleteView.layoutIfNeeded()
            }
        }
    }
    
    private func changeConstraints(of actionView: WatchItemActionView, with newConstant: CGFloat) {
        if abs(newConstant) >= AppStyle.watchItemEditRemoveWidth {
            if actionView.initialConstraint.isActive { actionView.initialConstraint.isActive = false }
            if !actionView.activeConstraint.isActive { actionView.activeConstraint.isActive = true }
        } else {
            if !actionView.initialConstraint.isActive { actionView.initialConstraint.isActive = true }
            if actionView.activeConstraint.isActive { actionView.activeConstraint.isActive = false }
        }
    }
    
    private func showActionView(for xPoint: CGFloat) {
        let shouldKeepHidden = abs(xPoint) <= AppStyle.watchItemEditHideActionViewGap && ((gestureRecognizer.direction == .right && currentEditState == .toWatched) || (gestureRecognizer.direction == .left && currentEditState == .toDelete))
        guard !shouldKeepHidden else { return }
        
        let newAlpha = (abs(xPoint) - AppStyle.watchItemEditHideActionViewGap) / (AppStyle.watchItemEditActionViewWidth - AppStyle.watchItemEditHideActionViewGap)
        
        UIView.animate(withDuration: 0.01) {
            self.activeActionView.alpha = newAlpha <= 1 ? newAlpha : 1
        }
    }
    
    // MARK: - Pan gesture 'End' state
    private func handleEndState() {
        guard currentEditState != .default else { return }
        guard abs(leftMainConstraint.constant) != AppStyle.watchItemEditActionViewWidth else { return }
        
        let state = getEndState()
        moveViewToEndState(state)
    }
    
    private func getEndState() -> WatchItemEditEndState {
        var endState: WatchItemEditEndState = .default
        
        var widthXPoint = AppStyle.watchItemEditActionViewWidth
        var currentXPoint = leftMainConstraint.constant
        var forwardDirection: UIPanGestureRecognizer.GestureDirection = .right
        var backwardDirection: UIPanGestureRecognizer.GestureDirection = .left
        
        var shouldReturnToDefault = false
        var shouldAnimateRemoving = false
        
        if currentEditState == .toDelete {
            widthXPoint = -AppStyle.watchItemEditActionViewWidth
            currentXPoint = -leftMainConstraint.constant
            forwardDirection = .left
            backwardDirection = .right
        }

        shouldReturnToDefault = (gestureRecognizer.direction == forwardDirection && currentXPoint < AppStyle.watchItemEditEndMovingViewGap) || (gestureRecognizer.direction == backwardDirection && (AppStyle.watchItemEditActionViewWidth - currentXPoint) > AppStyle.watchItemEditEndMovingViewGap) || currentXPoint < 0
        
        shouldAnimateRemoving = currentXPoint >= AppStyle.watchItemEditRemoveWidth
        
        if shouldReturnToDefault {
            endState = .default
        } else if shouldAnimateRemoving {
            endState = .remove
        } else {
            endState = .active(widthXPoint)
        }
        
        return endState
    }
    
    private func moveViewToEndState(_ endState: WatchItemEditEndState, duration: Double = 0.1, withAnimation: Bool = true) {
        switch endState {
        case .default:
            currentEditState = .default
            moveView(0.0, duration: duration, alpha: 0.0, withAnimation: withAnimation)
            
        case .active(let widthXPoint):
            moveView(widthXPoint, duration: duration, alpha: 1.0, withAnimation: withAnimation)
            
        case .remove:
            itemRemovedCallback?()
        }
    }
    
    private func moveView(_ constant: CGFloat, duration: Double = 0.1, alpha: CGFloat, withAnimation: Bool = true) {
        if withAnimation {
            UIView.animate(withDuration: duration) {
                self.changeConstraints(constant, isForAnimation: true)
                self.activeActionView.alpha = alpha
                
                self.impactFeedbackgenerator.impactOccurred()
            }
        } else {
            layoutIfNeeded()
            activeActionView.alpha = alpha
        }
    }
    
    private func changeConstraints(_ constant: CGFloat, isForAnimation: Bool = false) {
        leftMainConstraint.constant = constant
        rightMainConstraint.constant = constant
        watchedConstraint.constant = constant
        deleteConstraint.constant = constant
        
        if isForAnimation {
            layoutIfNeeded()
        }
    }
}

// MARK: - Animation
extension WatchItemView {
    func animateRemoving(_ completion: ((Bool) -> ())?) {
        isRemoving = true
        
        var direction: CGFloat = 1
        var hidingView = UIView()
        
        switch currentEditState {
        case .toWatched:
            direction = 1
            hidingView = watchedView
        case .toDelete:
            direction = -1
            hidingView = deleteView
        default: break
        }
        
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { hidingView.alpha = 0.0 },
                       completion: completion)
        UIView.animate(withDuration: AppStyle.animationDuration,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { self.changeConstraints((AppStyle.screenWidth + 80) * direction, isForAnimation: true) },
                       completion: { _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + AppStyle.animationDuration) {
                                self.changeConstraints(0.0)
                            }
                        })
    }
}
