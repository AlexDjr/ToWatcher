//
//  WatchItemsVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 12/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class WatchItemsVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, WatchItemEditProtocol {
    weak var homeVC: HomeVC?
    
    var watchItems: [WatchItem] = []
    var collectionView: WatchItemCollectionView!
    weak var delegate: WatchItemDelegateProtocol?
    
    private var childViewController: UIViewController?
    private var selectedIndexPath: IndexPath?
    private var isEditMode = false
    
    init(homeVC: HomeVC) {
        self.homeVC = homeVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if collectionView == nil {
            setupCollectionView()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLongPressGesture()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: AppStyle.itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: AppStyle.menuViewHeight + AppStyle.arrowViewHeight, left: 0.0, bottom: 0, right: 0.0)
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath != self.collectionView.selectedIndexPath else { return }
        
        self.view.bringSubviewToFront(collectionView)
        delegate?.didSelectItem(isEditMode: false)
        
        selectedIndexPath = indexPath
        self.collectionView.selectedIndexPath = indexPath
        
        moveItemsExceptSelectedFromScreen()
    }

    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return watchItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WatchItemCell.reuseIdentifier, for: indexPath) as! WatchItemCell
        cell.watchItem = watchItems[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    // MARK: - WatchItemEditProtocol
    func didRemoveItem(_ item: WatchItem, withType type: WatchItemEditState) {
        guard let index = (watchItems.firstIndex { $0 == item }) else { return }
        deleteCell(at: IndexPath(item: index, section: 0))
        homeVC?.didRemoveItem(item, withType: type)
    }
    
    // MARK: - Public methods
    func moveAllItemsFromScreen() {
        collectionView.fromScreenFinishedCallback = {
            self.showSearchVC()
            self.collectionView.isUserInteractionEnabled = false
            self.delegate?.didFinishMoveItemsFromScreen()
        }
        
        collectionView.animateItems(withType: .allItems, andDirection: .fromScreen)
    }
    
    func moveItemsBackToScreen() {
        if collectionView.selectedIndexPath != nil {
            moveItemsExceptSelectedBackToScreen()
        } else {
            moveAllItemsBackToScreen()
        }
        collectionView.isUserInteractionEnabled = true
    }
    
    func moveItemsEditMode() {
        if isEditMode {
            isEditMode = false
            enableScroll(true)
            
            collectionView.backToScreenFinishedCallback = {
                self.delegate?.didFinishMoveItemsBackToScreen(isEditMode: true)
            }
            
            collectionView.goFromEditMode()
            collectionView.animateItems(withType: .editMode, andDirection: .backToScreen)
            
        } else {
            isEditMode = true
            enableScroll(false)
            
            collectionView.fromScreenFinishedCallback = {
                self.delegate?.didFinishMoveItemsFromScreen()
            }
            
            collectionView.goToEditMode()
            collectionView.animateItems(withType: .editMode, andDirection: .fromScreen)
        }
    }
    
    func addItem(_ item: WatchItem) {
        if let collectionView = collectionView {
            watchItems.insert(item, at: 0)
            collectionView.reloadData()
        } else {
            setupCollectionView()
            watchItems.insert(item, at: 0)
            collectionView.reloadData()
        }
    }
    
    // MARK: - Private methods
    private func setupCollectionView() {
        let layout = setupCollectionViewLayout()
        
        collectionView = WatchItemCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        collectionView!.register(WatchItemCell.self, forCellWithReuseIdentifier: WatchItemCell.reuseIdentifier)
    }
    
    private func setupCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = AppStyle.itemsLineSpacing
        return layout
    }
    
    private func deleteCell(at indexPath: IndexPath) {
        moveItemsEditMode()
        watchItems.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
    
    // MARK: - Gestures
    private func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressedItem))
        longPressGesture.minimumPressDuration = 0.5
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func didLongPressedItem(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedbackgenerator.prepare()
            
            let touchPoint = gestureRecognizer.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: touchPoint) {
                impactFeedbackgenerator.impactOccurred()

                if isEditMode {
                    moveItemsEditMode()
                } else {
                    collectionView.selectedIndexPath = indexPath
                    delegate?.didSelectItem(isEditMode: true)
                    moveItemsEditMode()
                }
            }
        }
    }
    
    // MARK: - Items animation
    private func moveItemsExceptSelectedFromScreen() {
        collectionView.animateItems(withType: .itemSelected, andDirection: .fromScreen)
        collectionView.fromScreenFinishedCallback = {
            self.showWatchItemInfoVC()
            self.collectionView.isUserInteractionEnabled = false
            self.delegate?.didFinishMoveItemsFromScreen()
        }
    }
    
    private func moveItemsExceptSelectedBackToScreen() {
        removeChildViewController(childViewController)
        childViewController = nil
        
        collectionView.backToScreenFinishedCallback = {
            self.delegate?.didFinishMoveItemsBackToScreen(isEditMode: false)
        }
        
        collectionView.animateItems(withType: .itemSelected, andDirection: .backToScreen)
    }
    
    private func moveAllItemsBackToScreen() {
        collectionView.backToScreenFinishedCallback = {
            self.delegate?.didFinishMoveItemsBackToScreen(isEditMode: false)
        }
        
        collectionView.animateItems(withType: .allItems, andDirection: .backToScreen)
    }
    
    private func enableScroll(_ isEnabled: Bool) {
        if isEnabled {
            collectionView.isScrollEnabled = true
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            // this is to prevent "bouncing" behaviour of selected cell while animating other (not selected) cells for edit mode
            let newTopInset = collectionView.contentInset.top + AppStyle.topSafeAreaHeight
            let newBottomInset = collectionView.contentInset.bottom + AppStyle.bottomSafeAreaHeight
            collectionView.contentInset = UIEdgeInsets(top: newTopInset, left: 0, bottom: newBottomInset, right: 0)
            collectionView.isScrollEnabled = false
        }
    }
    
    // MARK: - Work with VCs
    private func showWatchItemInfoVC() {
        childViewController = WatchItemInfoVC()
        add(asChildViewController: childViewController)
    }
    
    private func showSearchVC() {
        childViewController = SearchVC()
        add(asChildViewController: childViewController)
    }
    
    private func setupTopAnchorConstant(forViewController viewController: UIViewController) -> CGFloat {
        var topAnchorConstant: CGFloat = 0.0
        if viewController is WatchItemInfoVC {
            topAnchorConstant = AppStyle.topSafeAreaHeight + AppStyle.itemHeight
        } else if viewController is SearchVC {
            topAnchorConstant = AppStyle.topSafeAreaHeight
        }
        return topAnchorConstant
    }
    
    private func add(asChildViewController viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        let topAnchorConstant = setupTopAnchorConstant(forViewController: viewController)
        setupViewController(viewController, withTopAnchorConstant: topAnchorConstant)
    }
    
    private func removeChildViewController(_ viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func setupViewController(_ viewController: UIViewController, withTopAnchorConstant topAnchorConstant: CGFloat) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: topAnchorConstant).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        viewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

}
