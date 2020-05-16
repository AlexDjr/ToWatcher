//
//  MenuBar.swift
//  ToWatcher
//
//  Created by Alex Delin on 17/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: MenuItemDelegateProtocol?
    
    var menuView: UICollectionView!
    var selectedIndexPath: IndexPath? {
        didSet {
            menuView.reloadData()
        }
    }
    
    private var arrowView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let menuItem = menuItems[indexPath.item]
        
        var cell = MenuItemCell()
        var reuseIdentifier: String
        
        switch menuItem.type {
        case .empty: reuseIdentifier = MenuItemCell.reuseIdentifierEmpty
        case .toWatch: reuseIdentifier = MenuItemCell.reuseIdentifierToWatch
        case .watched: reuseIdentifier = MenuItemCell.reuseIdentifierWatched
        }
        
        cell = menuView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MenuItemCell
        cell.menuItem = menuItem
        cell.itemState = indexPath == selectedIndexPath ? .active : .inactive        
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        let delegateIndexPath = IndexPath(item: indexPath.item  - 1, section: 0)
        delegate?.didSelectMenuItem(at: delegateIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if menuItems[indexPath.item].name == nil {
            return false
        }
        return true
    }
    
    // MARK: - Public Methods
    func moveMenuBarFromScreen() {
        animateMenuBar(withAnimationDirection: .fromScreen)
    }
    
    func moveMenuBarBackToScreen() {
        animateMenuBar(withAnimationDirection: .backToScreen)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = AppStyle.menuBarBGColor
        setupMenuView()
        setupArrowView()
        selectFirstMenuItem()
    }
    
    private func setupMenuView() {
        let layout = setupCollectionViewLayout()
        
        menuView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        menuView.isScrollEnabled = false
        menuView.isPagingEnabled = true
        menuView.showsHorizontalScrollIndicator = false
        menuView.backgroundColor = AppStyle.menuBarBGColor
        menuView.dataSource = self
        menuView.delegate = self
        
        self.addSubview(menuView)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.topAnchor.constraint(equalTo: self.topAnchor, constant: UIApplication.shared.statusBarFrame.height).isActive = true
        menuView.heightAnchor.constraint(equalToConstant: AppStyle.menuViewHeight).isActive = true
        menuView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        menuView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        menuView.register(MenuItemCell.self, forCellWithReuseIdentifier: MenuItemCell.reuseIdentifierEmpty)
        menuView.register(MenuItemCell.self, forCellWithReuseIdentifier: MenuItemCell.reuseIdentifierToWatch)
        menuView.register(MenuItemCell.self, forCellWithReuseIdentifier: MenuItemCell.reuseIdentifierWatched)
    }
    
    private func setupArrowView() {
        arrowView = UIView(frame: CGRect.zero)
        
        self.addSubview(arrowView)
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.topAnchor.constraint(equalTo: menuView.bottomAnchor).isActive = true
        arrowView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        arrowView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        arrowView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        arrowView.backgroundColor = AppStyle.menuBarBGColor
        
        setupArrowImageView()
    }
    
    private func setupCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        return layout
    }
    
    private func setupArrowImageView() {
        let arrowImageView = UIImageView(image: AppStyle.arrowViewImage)
        arrowView.addSubview(arrowImageView)
        
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.topAnchor.constraint(equalTo: arrowView.topAnchor).isActive = true
        arrowImageView.centerXAnchor.constraint(equalTo: arrowView.centerXAnchor).isActive = true
    }
    
    private func selectFirstMenuItem() {
        selectedIndexPath = IndexPath(item: 1, section: 0)
    }
    
    // MARK: - Animations
    private func animateMenuBar(withAnimationDirection animationDirection: AnimatableCollectionView.AnimationDirection) {
            switch animationDirection {
            case .fromScreen:
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.transform = CGAffineTransform(translationX: 0, y: -AppStyle.menuBarFullHeight)
                })
            case .backToScreen:
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.transform = .identity
                })
            }
    }
}
