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
        setupMenuView()
        setupArrowView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //   MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuView.dequeueReusableCell(withReuseIdentifier: "menuCellId", for: indexPath) as! MenuItemCell
        
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
        let itemIndex = indexPath.item
        if itemIndex != 0 && itemIndex != menuItems.count - 1 {
            collectionView.selectItem(at: IndexPath(item: indexPath.item , section: 0), animated: true, scrollPosition: .centeredHorizontally)
            menuItems = menuItems.map { (item) -> MenuItem in
                item.state = .inactive
                return item
            }
            menuItems[itemIndex].state = .active
            collectionView.reloadData()
        }
    }
    
    //    MARK: - Methods
    func setupMenuView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        menuView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        menuView.isScrollEnabled = false
        menuView.isPagingEnabled = true
        menuView.showsHorizontalScrollIndicator = false
        menuView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        menuView.dataSource = self
        menuView.delegate = self
        self.addSubview(menuView)
        
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.topAnchor.constraint(equalTo: self.topAnchor, constant: UIApplication.shared.statusBarFrame.height).isActive = true
        menuView.heightAnchor.constraint(equalToConstant: 88).isActive = true
        menuView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        menuView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        menuView.register(MenuItemCell.self, forCellWithReuseIdentifier: "menuCellId")
    }
    
    func setupArrowView() {
        arrowView = UIView(frame: CGRect.zero)
        self.addSubview(arrowView)
        
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.topAnchor.constraint(equalTo: menuView.bottomAnchor).isActive = true
        arrowView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        arrowView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        arrowView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        arrowView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let arrowImageView = UIImageView(image: #imageLiteral(resourceName: "arrow-down"))
        arrowView.addSubview(arrowImageView)
        
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.topAnchor.constraint(equalTo: arrowView.topAnchor).isActive = true
        arrowImageView.centerXAnchor.constraint(equalTo: arrowView.centerXAnchor).isActive = true
    }
}
