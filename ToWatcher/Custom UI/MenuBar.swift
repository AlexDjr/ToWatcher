//
//  MenuBar.swift
//  ToWatcher
//
//  Created by Alex Delin on 17/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var menuView: UICollectionView!
    var arrowView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //   MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuView.dequeueReusableCell(withReuseIdentifier: MenuItemCell.reuseIdentifier, for: indexPath) as! MenuItemCell
        
        cell.itemImage = menuItems[indexPath.item].image
        cell.itemName = menuItems[indexPath.item].name
        cell.itemState = menuItems[indexPath.item].state
        
        return cell
    }
    
    //    MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    //    MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = menuItems[indexPath.item]
        let isItemNotEmpty = item.state != .empty
        
        if isItemNotEmpty {
            collectionView.selectItem(at: IndexPath(item: indexPath.item , section: 0), animated: true, scrollPosition: .centeredHorizontally)
            item.state = .active
            makeItemsInactiveExcept(item)
            collectionView.reloadData()
        }
    }
    
    //    MARK: - Methods
    private func setupView() {
        backgroundColor = AppStyle.menuBarBGColor
        setupMenuView()
        setupArrowView()
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
        
        menuView.register(MenuItemCell.self, forCellWithReuseIdentifier: MenuItemCell.reuseIdentifier)
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
    
    private func makeItemsInactiveExcept(_ exceptedItem: MenuItem) {
        menuItems = menuItems.map { (item) -> MenuItem in
            let isItemNotEmpty = item.state != .empty
            
            if isItemNotEmpty && item != exceptedItem {
                item.state = .inactive
            }
            return item
        }
    }
}
