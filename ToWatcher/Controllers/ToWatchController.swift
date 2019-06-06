//
//  ToWatchController.swift
//  ToWatcher
//
//  Created by Alex Delin on 23/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class ToWatchController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    let array: [UIImage] = [#imageLiteral(resourceName: "6"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "5")]
    
    var collectionView: UICollectionView!
    
    weak var delegate: ToWatchDelegateProtocol?
    
    private var selectedIndexPath: IndexPath?
    private var firstItemIndexPath: IndexPath?
    private var lastItemIndexPath: IndexPath?
    
    private lazy var watchItemInfoController: WatchItemInfoController = {
        var viewController = WatchItemInfoController()
        return viewController
    }()
    
    enum AnimationType {
        case fromScreen
        case backToScreen
    }
    
    enum AnimatedItemType {
        case over
        case under
        case selected
    }
    
    typealias AnimationParams = (delay: TimeInterval, transform: CGAffineTransform?, completion: ((Bool) -> ())?)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WatchItemCell.reuseIdentifier, for: indexPath) as! WatchItemCell
        cell.itemImage = array[indexPath.item]
        return cell
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
        moveItemsFromScreen()
    }
    
    //    MARK: - Methods
    private func setupCollectionView() {
        let layout = setupCollectionViewLayout()
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
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
    
    private func setupCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = round(AppStyle.itemHeight / 20)
        return layout
    }
    
    func moveItemsFromScreen() {
        animateItems(withAnimationType: .fromScreen)
    }
    
    func moveItemsBackToScreen() {
        removeChildViewController(watchItemInfoController)
        animateItems(withAnimationType: .backToScreen)
    }
    
    private func animateItems(withAnimationType animationType: AnimationType) {
        guard let selectedIndexPath = selectedIndexPath else { return }
        
        let items = collectionView.visibleCells.sorted { $0.frame.maxY < $1.frame.maxY }
        firstItemIndexPath = collectionView.indexPath(for: items.first!)!
        lastItemIndexPath = collectionView.indexPath(for: items.last!)!
        
        guard let _ = firstItemIndexPath, let _ = lastItemIndexPath else { return }
        
            for item in items {
                let itemIndexPath = collectionView.indexPath(for: item)!
                
                if itemIndexPath.item < selectedIndexPath.item {
                    animate(item, withAnimationType: animationType, andItemType: .over)
                } else if itemIndexPath.item > selectedIndexPath.item {
                    animate(item, withAnimationType: animationType, andItemType: .under)
                } else if itemIndexPath.item == selectedIndexPath.item {
                    animate(item, withAnimationType: animationType, andItemType: .selected)
                }
            }
    }
    
    private func animate(_ item: UICollectionViewCell, withAnimationType animationType: AnimationType, andItemType animatedItemType: AnimatedItemType) {
        let delay = setupAnimationParams(for: item, with: animationType, and: animatedItemType).delay
        let transform = setupAnimationParams(for: item, with: animationType, and: animatedItemType).transform
        let completion = setupAnimationParams(for: item, with: animationType, and: animatedItemType).completion
        
        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       options: .curveEaseInOut,
                       animations: { item.transform = transform! },
                       completion: completion)
    }
    
    private func setupAnimationParams(for item: UICollectionViewCell, with animationType: ToWatchController.AnimationType, and animatedItemType: ToWatchController.AnimatedItemType) -> (AnimationParams) {
        let itemIndexPath = collectionView.indexPath(for: item)!
        var delay: TimeInterval = 0.0
        var transform: CGAffineTransform? = nil
        var completion: ((Bool) -> ())? = nil
        
        if animationType == .fromScreen {
            switch animatedItemType {
            case .over:
                hideIfNeeded(item)
                delay = 0.1 * Double(itemIndexPath.item - firstItemIndexPath!.item + 1)
                transform = CGAffineTransform.init(translationX: 0, y: -1000)
                completion = nil
            case .under:
                delay = 0.1 * Double(lastItemIndexPath!.item - itemIndexPath.item + 1)
                transform = CGAffineTransform.init(translationX: 0, y: 1000)
                completion = nil
            case .selected:
                delay = 0.1 * Double(max(lastItemIndexPath!.item - selectedIndexPath!.item, selectedIndexPath!.item - firstItemIndexPath!.item) + 1)
                
                let frameInView = view.convert(item.frame, from: self.collectionView)
                transform = CGAffineTransform.init(translationX: 0, y: -(frameInView.minY - AppStyle.topSafeArea))
                completion = { finished in
                    if finished {
                        self.runActionsAfterAnimation(for:item, with: animationType, and: animatedItemType)
                    }
                }
            }
        } else if animationType == .backToScreen {
            switch animatedItemType {
            case .over:
                delay = 0.1 * Double(selectedIndexPath!.item - itemIndexPath.item)
                transform = CGAffineTransform.identity
                completion = { finished in
                    if finished {
                        self.runActionsAfterAnimation(for:item, with: animationType, and: animatedItemType)
                    }
                }
            case .under:
                delay = 0.1 * Double(itemIndexPath.item - selectedIndexPath!.item)
                transform = CGAffineTransform.identity
                completion = nil
            case .selected:
                delay = 0.0
                transform = CGAffineTransform.identity
                completion = { finished in
                    if finished {
                        self.runActionsAfterAnimation(for:item, with: animationType, and: animatedItemType)
                    }
                }
            }
        }
        return (delay, transform, completion)
    }
    
    private func runActionsAfterAnimation(for item: UICollectionViewCell, with animationType: ToWatchController.AnimationType, and animatedItemType: ToWatchController.AnimatedItemType) {
        if animationType == .fromScreen {
            if animatedItemType == .selected {
                showWatchItemInfo()
            }
        } else if animationType == .backToScreen {
            let itemIndexPath = collectionView.indexPath(for: item)!
            let isTopItemMovedBack = itemIndexPath == self.firstItemIndexPath!
            
            if isTopItemMovedBack {
                self.delegate?.didFinishMoveItemsBack()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.unHideIfNeeded(item)
            }
        }
    }
    
    private func hideIfNeeded(_ item: UICollectionViewCell) {
        let frameInView = self.view.convert(item.frame, from: self.collectionView)
        let isItemFullyUnderMenubar = frameInView.minY < AppStyle.menuBarFullHeight && frameInView.maxY <= AppStyle.menuBarFullHeight;
        
        if isItemFullyUnderMenubar {
            item.isHidden = true
        }
    }
    
    private func unHideIfNeeded(_ item: UICollectionViewCell) {
        if item.isHidden {
            item.isHidden = false
        }
    }
    
    private func showWatchItemInfo() {        
        watchItemInfoController = WatchItemInfoController()
        add(asChildViewController: watchItemInfoController)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: AppStyle.topSafeArea + AppStyle.itemHeight).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        viewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func removeChildViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
