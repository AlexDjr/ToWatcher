//
//  SearchVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 07/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var searchView: SearchView!
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - AppStyle.searchItemLeftRightPadding * 2
        return CGSize(width: width, height: AppStyle.searchItemMainViewHeight)
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toWatchItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCell.reuseIdentifier, for: indexPath) as! SearchItemCell
        cell.watchItem = toWatchItems[indexPath.item]
        // cell.delegate = self
        return cell
    }

    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.alpha = 0.0
        
        setupSearchView()
        setupCollectionView()
        
        animateShowView()
        setFocusOnSearchView()
    }
    
    private func setupSearchView() {
        searchView = SearchView()
        view.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.topAnchor.constraint(equalTo: view.topAnchor, constant: AppStyle.searchViewTopBottomPadding).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: AppStyle.searchViewHeight).isActive = true
        searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: AppStyle.searchViewLeftRightPadding).isActive = true
        searchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -AppStyle.searchViewLeftRightPadding).isActive = true
    }
    
    private func setupCollectionView() {
        let layout = setupCollectionViewLayout()
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: AppStyle.searchViewTopBottomPadding).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        collectionView!.register(SearchItemCell.self, forCellWithReuseIdentifier: SearchItemCell.reuseIdentifier)
    }
    
    private func setupCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = AppStyle.itemsLineSpacing
        return layout
    }
    
    private func animateShowView() {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1.0
        }
    }
    
    private func setFocusOnSearchView() {
        searchView.textField.becomeFirstResponder()
    }
}
