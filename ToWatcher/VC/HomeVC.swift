//
//  HomeVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 17/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, WatchItemDelegateProtocol, MenuItemDelegateProtocol, WatchItemEditProtocol {

    private var childControllers: [WatchItemsVC]?
    private var selectedChildVC: WatchItemsVC?
    
    private var containerView: UICollectionView!
    private var floatActionButton = FloatActionButton()
    private let menuBar = MenuBar()
    
    private var lastContentOffset: CGPoint = CGPoint()
    
    private lazy var reviewController = ReviewController()
    
    var currentScreen: ScreenType = .default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        setupChildControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openSearchIfNeeded()
        
        setupMenuBar()
        setupFloatActionButton()
        floatActionButton.addTarget(self, action: #selector(pressFloatActionButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTopAndBottomSafeArea()
    }
    
    // MARK: - Public methods
    func enableInteractions(_ isEnabled: Bool) {
        menuBar.isUserInteractionEnabled = isEnabled
    }
    
    func openSearch() {
        switch currentScreen {
        case .toWatch, .watched: pressFloatActionButton()
        case .info:
            pressFloatActionButton()
            DispatchQueue.main.asyncAfter(deadline: .now() + AppStyle.animationDuration * 2) {
                self.pressFloatActionButton()
            }
        case .search, .default: break
        }
    }
    
    //   MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let childControllers = childControllers else { return UICollectionViewCell() }
        let cell = containerView.dequeueReusableCell(withReuseIdentifier: ContainerCell.reuseIdentifier, for: indexPath) as! ContainerCell

        cell.hostedView = childControllers[indexPath.item].view
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentOffset = containerView.contentOffset
        
        scrollMenuBar(withOffset: currentContentOffset)
        selectMenuItem(withOffset: currentContentOffset)
        
        lastContentOffset = currentContentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setupSelectedChildController()
    }
    
    // MARK: - WatchItemDelegateProtocol
    func didSelectItem(isEditMode: Bool) {
        containerView.isUserInteractionEnabled = false
        floatActionButton.isUserInteractionEnabled = false

        if isEditMode {
            floatActionButton.isButtonHidden = true
        } else {
            floatActionButton.actionState = .close
            menuBar.moveMenuBarFromScreen()
        }
    }
    
    func didFinishMoveItemsFromScreen() {
        containerView.isScrollEnabled = false
        floatActionButton.isUserInteractionEnabled = true
        containerView.isUserInteractionEnabled = true
    }
    
    func didFinishMoveItemsBackToScreen(isEditMode: Bool) {
        containerView.isScrollEnabled = true
        floatActionButton.isUserInteractionEnabled = true
        containerView.isUserInteractionEnabled = true
        if isEditMode {
            floatActionButton.isButtonHidden = false
        } else {
            menuBar.moveMenuBarBackToScreen()
        }
    }
    
    func didAddItemAfterSearch() {
        menuBar.menuView.reloadData()
        pressFloatActionButton()
    }
    
    // MARK: - WatchItemEditProtocol
    func didRemoveItem(_ item: WatchItem, withType type: WatchItemEditState) {
        menuBar.menuView.reloadData()
    
        reviewController.checkForReview(screen: currentScreen, type: type)
        
        if selectedChildVC is ToWatchVC, type == .toWatched {
            guard let watchedVC = childControllers?[1] else { return }
            watchedVC.addItem(item)
        }
    }
    
    // MARK: - MenuItemDelegateProtocol
    func didSelectMenuItem(at indexPath: IndexPath) {
        containerView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        guard let childControllers = childControllers else { return }
        selectedChildVC = childControllers[indexPath.item]
        setCurrentScreen(indexPath.item)
    }
    
    // MARK: - Private methods
    private func setupChildControllers() {
        let toWatchVC = ToWatchVC(homeVC: self)
        toWatchVC.delegate = self
        self.add(asChildVC: toWatchVC)
        
        let watchedVC = WatchedVC(homeVC: self)
        watchedVC.delegate = self
        self.add(asChildVC: watchedVC)
        
        childControllers = [toWatchVC, watchedVC]
        selectedChildVC = childControllers?[0]
    }
    
    private func setupSelectedChildController() {
        guard let childControllers = childControllers else { return }
        let controllerIndex = containerView.indexPathsForVisibleItems.first!.item
        selectedChildVC = childControllers[controllerIndex]
        setCurrentScreen(controllerIndex)
    }
    
    private func setupTopAndBottomSafeArea() {
        if #available(iOS 11.0, *) {
            AppStyle.topSafeAreaHeight = view.safeAreaInsets.top
            AppStyle.bottomSafeAreaHeight = view.safeAreaInsets.bottom
        } else {
            AppStyle.topSafeAreaHeight = topLayoutGuide.length
            AppStyle.bottomSafeAreaHeight = bottomLayoutGuide.length
        }
    }
    
    private func setupContainerView() {
        let layout = setupContainerViewLayout()
        
        containerView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        containerView.isPagingEnabled = true
        containerView.showsHorizontalScrollIndicator = false
        containerView.backgroundColor = .clear
        containerView.dataSource = self
        containerView.delegate = self
        
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        containerView.register(ContainerCell.self, forCellWithReuseIdentifier: ContainerCell.reuseIdentifier)
    }
    
    private func setupContainerViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        return layout
    }
    
    private func setupMenuBar() {
        menuBar.delegate = self
        
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: AppStyle.menuBarFullHeight).isActive = true
        menuBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func setupFloatActionButton() {
        view.addSubview(floatActionButton)
        floatActionButton.translatesAutoresizingMaskIntoConstraints = false
        floatActionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -AppStyle.floatActionButtonPadding - AppStyle.bottomSafeAreaHeight).isActive = true
        floatActionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        floatActionButton.heightAnchor.constraint(equalToConstant: AppStyle.floatActionButtonHeight).isActive = true
        floatActionButton.widthAnchor.constraint(equalToConstant: AppStyle.floatActionButtonHeight).isActive = true
    }
    
    private func add(asChildVC vc: UIViewController) {
        addChild(vc)
        vc.didMove(toParent: self)
    }
    
    private func openSearchIfNeeded() {
        if Settings.startScreen == .search {
            openSearch()
        }
    }
    
    private func setCurrentScreen(_ index: Int) {
        guard let screen = (childControllers?[index])?.screen else { return }
        currentScreen = screen
    }
    
    // MARK: - MenuBar
    private func scrollMenuBar(withOffset offset: CGPoint) {
        var scrollBounds = menuBar.menuView.bounds
        scrollBounds.origin = CGPoint(x: offset.x / 3, y: scrollBounds.origin.y)
        menuBar.menuView.bounds = scrollBounds
    }
    
    private func selectMenuItem(withOffset offset: CGPoint) {
        let screenWidthHalf = AppStyle.screenWidth / 2
        let isScrolledToNextItem = lastContentOffset.x <= screenWidthHalf && offset.x >= screenWidthHalf
        let isScrolledToPreviousItem = lastContentOffset.x >= screenWidthHalf && offset.x <= screenWidthHalf
        
        if isScrolledToNextItem {
            let indexPath = containerView.indexPathForVisibleItem(withOffset: offset)!
            menuBar.selectedIndexPath = translateToMenuBarIndexPath(indexPath)
        } else if isScrolledToPreviousItem {
            let indexPath = containerView.indexPathForVisibleItem(withOffset: offset)!
            menuBar.selectedIndexPath = translateToMenuBarIndexPath(indexPath)
        }
    }
    
    private func translateToMenuBarIndexPath(_ indexPath: IndexPath?) -> IndexPath? {
        guard let indexPath = indexPath else { return nil }
        return IndexPath(item: indexPath.item + 1, section: indexPath.section)
    }
    
    // MARK: - Actions
    @objc func pressFloatActionButton() {
        containerView.isUserInteractionEnabled = false
        floatActionButton.isUserInteractionEnabled = false
        switch floatActionButton.actionState {
        case .add:
            floatActionButton.actionState = .close
            selectedChildVC?.moveAllItemsFromScreen()
            menuBar.moveMenuBarFromScreen()
        case .close:
            floatActionButton.actionState = .add
            selectedChildVC?.moveItemsBackToScreen()
        }
    }
}
