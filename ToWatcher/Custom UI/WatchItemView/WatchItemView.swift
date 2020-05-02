//
//  WatchItemView.swift
//  SwipeTest
//
//  Created by Alex Delin on 02.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

class WatchItemView: UIView {
    private var mainView = WatchItemMainView()
    private var deleteView = WatchItemActionView(.delete)
    private var watchedView = WatchItemActionView(.watched)
    
    private var gestureRecognizer = UIPanGestureRecognizer()
    private let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
    
    private var currentCellState: WatchItemEditState = .active {
        didSet { setupCellState() }
    }
    
    private var activeActionView = UIView()
    private let actionViewWidth: CGFloat = 100.0
    private let actionViewMoveWidth: CGFloat = 200.0
    private let hideActionViewGap: CGFloat = 25.0
    
    private let stickToFrameGap: CGFloat = 10.0
    private let endMovingViewGap: CGFloat = 25.0
    
    private var leftMainConstraint: NSLayoutConstraint!
    private var rightMainConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func setImage(_ image: UIImage) {
        mainView.setImage(image)
    }
    
    func setupState(_ state: WatchItemCell.State) {
        mainView.setupState(state)
        switch state {
        case .editing: gestureRecognizer.isEnabled = true
        default: gestureRecognizer.isEnabled = false
        }
    }
    
    // MARK: - Private methods
    private func setupView() {
//        layer.masksToBounds = false
//        clipsToBounds = false
        
        add(watchedView)
        add(deleteView)
        addMainView()
        setupActionViewActiveConstraints()
        
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
    
    private func add(_ view: UIView) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func setupActionViewActiveConstraints() {
        watchedView.activeConstraint = watchedView.actionView.rightAnchor.constraint(equalTo: mainView.leftAnchor)
        deleteView.activeConstraint = deleteView.actionView.leftAnchor.constraint(equalTo: mainView.rightAnchor)
    }
    
    private func setupCellState() {
        switch currentCellState {
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
        guard currentCellState == .active else { return }
        changeCellState()
        activeActionView.alpha = 0.0
    }
    
    private func changeCellState() {
        switch gestureRecognizer.direction {
        case .right: currentCellState = .toWatched
        case .left: currentCellState = .toDelete
        }
    }
    
    // MARK: - Pan gesture 'Change' state
    private func handleChangeState() {
        let translationPoint = gestureRecognizer.translation(in: self)
        
        let currentXPoint = leftMainConstraint.constant
        let newXPoint = getXPoint(from: translationPoint)
        
        let shouldViewStickToFrame = currentXPoint == 0.0 && abs(newXPoint) < stickToFrameGap
        guard !shouldViewStickToFrame else { return }
        
        //        let canMoveView = abs(newXPoint) <= actionViewWidth && newXPoint != currentXPoint
        //        guard canMoveView else { return }
        
        switchCellStateIfNeeded(current: currentXPoint, new: newXPoint)
        moveView(newXPoint)
        showActionView(for: newXPoint)
        gestureRecognizer.setTranslation(.zero, in: self)
    }
    
    private func getXPoint(from translationPoint: CGPoint) -> CGFloat {
        var xPoint = leftMainConstraint.constant + translationPoint.x
        
        //        let isMaxWidthReached = abs(leadingConstraint.constant) < actionViewWidth && abs(xPoint) > actionViewWidth
        //        if isMaxWidthReached {
        //            xPoint = xPoint > 0 ? actionViewWidth : -actionViewWidth
        //        }
        
        let shouldStickToFrame = abs(xPoint) < stickToFrameGap
        if shouldStickToFrame {
            xPoint = 0.0
        }
        
        return xPoint
    }
    
    private func switchCellStateIfNeeded(current currentXPoint: CGFloat, new newXPoint: CGFloat) {
        if newXPoint == 0.0 && currentXPoint != 0.0 && currentCellState != .active {
            impactFeedbackgenerator.impactOccurred()
            currentCellState = .active
        } else if currentXPoint >= 0.0 && newXPoint < 0.0 && currentCellState != .toDelete {
            currentCellState = .toDelete
        } else if currentXPoint <= 0.0 && newXPoint > 0.0 && currentCellState != .toWatched {
            currentCellState = .toWatched
        }
    }
    
    private func moveView(_ newConstant: CGFloat) {
        leftMainConstraint.constant = newConstant
        rightMainConstraint.constant = newConstant
        UIView.animate(withDuration: 0.01) {
            self.mainView.superview?.layoutIfNeeded()
            //            if abs(newConstant) == self.actionViewWidth {
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
        if abs(newConstant) >= actionViewMoveWidth {
            if actionView.initialConstraint.isActive { actionView.initialConstraint.isActive = false }
            if !actionView.activeConstraint.isActive { actionView.activeConstraint.isActive = true }
        } else {
            if !actionView.initialConstraint.isActive { actionView.initialConstraint.isActive = true }
            if actionView.activeConstraint.isActive { actionView.activeConstraint.isActive = false }
        }
    }
    
    private func showActionView(for xPoint: CGFloat) {
        let shouldKeepHidden = abs(xPoint) <= hideActionViewGap && ((gestureRecognizer.direction == .right && currentCellState == .toWatched) || (gestureRecognizer.direction == .left && currentCellState == .toDelete))
        guard !shouldKeepHidden else { return }
        
        let newAlpha = (abs(xPoint) - hideActionViewGap) / (actionViewWidth - hideActionViewGap)
        
        UIView.animate(withDuration: 0.01) {
            self.activeActionView.alpha = newAlpha <= 1 ? newAlpha : 1
        }
    }
    
    // MARK: - Pan gesture 'End' state
    private func handleEndState() {
        guard currentCellState != .active else { return }
        guard abs(leftMainConstraint.constant) != actionViewWidth else { return }
        
        let params = getEndMovingParams()
        endMovingView(with: params)
    }
    
    private typealias EndMovingParams = (shouldReturnToActive: Bool, widthXPoint: CGFloat)
    
    private func getEndMovingParams() -> EndMovingParams {
        var widthXPoint: CGFloat = 0.0
        let direction = gestureRecognizer.direction
        
        var shouldReturnToActive = false
        switch self.currentCellState {
        case .toWatched:
            widthXPoint = actionViewWidth
            let currentXPoint = leftMainConstraint.constant
            shouldReturnToActive = (direction == .right && currentXPoint < endMovingViewGap) || (direction == .left && (actionViewWidth - currentXPoint) > endMovingViewGap) || currentXPoint < 0
        case .toDelete:
            widthXPoint = -actionViewWidth
            let currentXPoint = -leftMainConstraint.constant
            shouldReturnToActive = (direction == .left && currentXPoint < endMovingViewGap) || (direction == .right && (actionViewWidth - currentXPoint) > endMovingViewGap) || currentXPoint < 0
        default: break
        }
        
        return (shouldReturnToActive, widthXPoint)
    }
    
    private func endMovingView(with params: EndMovingParams) {
        let shouldReturnToActive = params.shouldReturnToActive
        let widthXPoint = params.widthXPoint
        
        var newAlpha: CGFloat = 0.0
        if shouldReturnToActive {
            leftMainConstraint.constant = 0.0
            rightMainConstraint.constant = 0.0
            newAlpha = 0.0
            currentCellState = .active
        } else {
            leftMainConstraint.constant = widthXPoint
            rightMainConstraint.constant = widthXPoint
            newAlpha = 1.0
        }
        
        UIView.animate(withDuration: 0.1) {
            self.mainView.superview?.layoutIfNeeded()
            self.activeActionView.alpha = newAlpha
            
            self.impactFeedbackgenerator.impactOccurred()
        }
    }
}
