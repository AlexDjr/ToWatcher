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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuView.dequeueReusableCell(withReuseIdentifier: "menuCellId", for: indexPath) as! MenuCell
        
        return cell
    }
    
    //    MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }    
    
    //    MARK: - Methods
    func setupMenuView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        menuView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        menuView.isPagingEnabled = true
        menuView.showsHorizontalScrollIndicator = false
        menuView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        menuView.dataSource = self
        menuView.delegate = self
        self.addSubview(menuView)
        
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.topAnchor.constraint(equalTo: self.topAnchor, constant: 44).isActive = true
        menuView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        menuView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        menuView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        menuView.register(MenuCell.self, forCellWithReuseIdentifier: "menuCellId")
    }
    
    func setupArrowView() {
        arrowView = UIView(frame: CGRect.zero)
        self.addSubview(arrowView)
        
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.topAnchor.constraint(equalTo: menuView.bottomAnchor).isActive = true
        arrowView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        arrowView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        arrowView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        arrowView.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        
        let arrowImageView = UIImageView(image: #imageLiteral(resourceName: "arrow-down"))
        arrowView.addSubview(arrowImageView)
        
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.centerXAnchor.constraint(equalTo: arrowView.centerXAnchor).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: arrowView.centerYAnchor).isActive = true
    }
}
