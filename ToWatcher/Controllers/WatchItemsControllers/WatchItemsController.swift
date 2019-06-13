//
//  WatchItemsController.swift
//  ToWatcher
//
//  Created by Alex Delin on 12/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class WatchItemsController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    var collectionView: AnimatableCollectionView!
    weak var delegate: WatchItemDelegateProtocol?
    
    private var childViewController: UIViewController?
    private var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //    MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: AppStyle.itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: AppStyle.menuViewHeight + AppStyle.arrowViewHeight, left: 0.0, bottom: 0, right: 0.0)
    }
    
    //    MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.bringSubviewToFront(collectionView)
        delegate?.didSelectItem()
        
        selectedIndexPath = indexPath
        self.collectionView.selectedIndexPath = indexPath
        
        moveItemsExceptSelectedFromScreen()
    }
    
    //    MARK: - Public methods
    func setupCollectionView() {
        let layout = setupCollectionViewLayout()
        
        collectionView = AnimatableCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
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
    
    func moveAllItemsFromScreen() {
        collectionView.animateItems(withType: .allItems, andDirection: .fromScreen)
        collectionView.fromScreenFinishedCallback = {
            self.showSearchController()
            self.collectionView.isUserInteractionEnabled = false
            self.delegate?.didFinishMoveItemsFromScreen()
        }
    }
    
    func moveItemsBackToScreen() {
        if collectionView.selectedIndexPath != nil {
            moveItemsExceptSelectedBackToScreen()
        } else {
            moveAllItemsBackToScreen()
        }
        self.collectionView.isUserInteractionEnabled = true
    }
    
    //    MARK: - Private methods
    private func setupCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = round(AppStyle.itemHeight / 20)
        return layout
    }
    
    private func moveItemsExceptSelectedFromScreen() {
        collectionView.animateItems(withType: .itemSelected, andDirection: .fromScreen)
        collectionView.fromScreenFinishedCallback = {
            self.showWatchItemInfoController()
            self.collectionView.isUserInteractionEnabled = false
            self.delegate?.didFinishMoveItemsFromScreen()
        }
    }
    
    private func moveItemsExceptSelectedBackToScreen() {
        removeChildViewController(childViewController)
        childViewController = nil
        
        collectionView.animateItems(withType: .itemSelected, andDirection: .backToScreen)
        collectionView.backToScreenFinishedCallback = {
            self.delegate?.didFinishMoveItemsBackToScreen()
        }
    }
    
    private func moveAllItemsBackToScreen() {
        collectionView.animateItems(withType: .allItems, andDirection: .backToScreen)
        collectionView.backToScreenFinishedCallback = {
            self.delegate?.didFinishMoveItemsBackToScreen()
        }
    }
    
    private func showWatchItemInfoController() {
        childViewController = WatchItemInfoController()
        add(asChildViewController: childViewController)
    }
    
    private func showSearchController() {
        childViewController = SearchController()
        add(asChildViewController: childViewController)
    }
    
    private func setupTopAnchorConstant(forViewController viewController: UIViewController) -> CGFloat {
        var topAnchorConstant: CGFloat = 0.0
        if viewController is WatchItemInfoController {
            topAnchorConstant = AppStyle.topSafeArea + AppStyle.itemHeight
        } else if viewController is SearchController {
            topAnchorConstant = AppStyle.topSafeArea
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
