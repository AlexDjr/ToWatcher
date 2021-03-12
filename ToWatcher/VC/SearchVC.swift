//
//  SearchVC.swift
//  ToWatcher
//
//  Created by Alex Delin on 07/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import NVActivityIndicatorView

class SearchVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchDelegate {
    private var searchView: SearchView!
    private var containerSearchView: UIView!
    private var collectionView: SearchItemCollectionView!
    
    private var selectedIndexPath: IndexPath?
    private var searchItems: [WatchItem] = []
    
    private var page = 1
    private var totalPages = 0
    private var searchString = ""
    
    private var loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: AppStyle.searchLoaderHeight, height: AppStyle.searchLoaderHeight), type: .ballRotateChase, color: AppStyle.menuItemToWatchCounterColor)
    
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
        return searchItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCell.reuseIdentifier, for: indexPath) as! SearchItemCell
        cell.watchItem = searchItems[indexPath.item]
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath != self.collectionView.selectedIndexPath else { return }
        
        self.view.bringSubviewToFront(collectionView)
        containerSearchView.isHidden = true
        selectedIndexPath = indexPath
        self.collectionView.selectedIndexPath = indexPath
        
        addSelectedItemToWatch()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: AppStyle.searchViewContainerHeight, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard page < totalPages else { return }
        
        let isLastItem = indexPath.item == searchItems.count - 1
        if isLastItem {
            loadMoreItems(indexPath.item)
        }
    }

    // MARK: - SearchDelegate
    func didSearchTextChanged(_ searchString: String) {
        guard !searchString.isEmpty else {
            searchItems = []
            collectionView.reloadData()
            return
        }
        
        print("searchString = \(searchString)")
        page = 1
        self.searchString = searchString
        
        let startSearchTime = Date().timeIntervalSince1970
        loader.startAnimating()
        
        search() { items, totalPages in
            let stopSearchTime = Date().timeIntervalSince1970
            let delta = Int((stopSearchTime - startSearchTime) * 1000)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000 - delta)) {
                self.loader.stopAnimating()
            }
            
            self.searchItems = items
            self.totalPages = totalPages
            self.page += 1
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.alpha = 0.0
        view.backgroundColor = AppStyle.mainBGColor
        setupCollectionView()
        setupSearchView()
        setupLoader()
        searchView.delegate = self
        
        animateShowView()
//        setFocusOnSearchView()
    }
    
    private func setupSearchView() {
        containerSearchView = UIView()
        containerSearchView.backgroundColor = AppStyle.mainBGColor
        view.addSubview(containerSearchView)
        
        containerSearchView.translatesAutoresizingMaskIntoConstraints = false
        containerSearchView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerSearchView.heightAnchor.constraint(equalToConstant: AppStyle.searchViewContainerHeight).isActive = true
        containerSearchView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerSearchView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        searchView = SearchView()
        containerSearchView.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.topAnchor.constraint(equalTo: containerSearchView.topAnchor, constant: AppStyle.searchViewTopBottomPadding).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: AppStyle.searchViewHeight).isActive = true
        searchView.leftAnchor.constraint(equalTo: containerSearchView.leftAnchor, constant: AppStyle.searchViewLeftRightPadding).isActive = true
        searchView.rightAnchor.constraint(equalTo: containerSearchView.rightAnchor, constant: -AppStyle.searchViewLeftRightPadding).isActive = true
    }
    
    private func setupLoader() {
        searchView.addSubview(loader)
        
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        loader.leftAnchor.constraint(equalTo: searchView.rightAnchor, constant: (AppStyle.searchViewLeftRightPadding - AppStyle.searchLoaderHeight) / 2).isActive = true
    }
    
    private func setupCollectionView() {
        let layout = setupCollectionViewLayout()
        
        collectionView = SearchItemCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
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
    
    private func search(_ completion: @escaping (SearchResult) -> ()) {
        NetworkManager.shared.search(searchString, page: page) { result in
            switch result {
            case .success(let searchResult):
                completion(searchResult)
                
            case .failure(let error):
                print("ERROR = \(error.localizedDescription)")
                self.loader.stopAnimating()
            }
        }
    }
    
    private func loadMoreItems(_ lastItem: Int) {
        search() { items, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.searchItems.append(contentsOf: items)
                
                var indexPaths: [IndexPath] = []
                for i in items.indices {
                    indexPaths.append(IndexPath(item: lastItem + 1 + i, section: 0))
                }
                
                self.collectionView.insertItems(at: indexPaths)
                self.page += 1
            }
        }
    }
    
    // MARK: - Items animation
    private func addSelectedItemToWatch() {
        let parent = self.parent as? WatchItemsVC
        parent?.fullReload()
        
        collectionView.animateItems(withType: .searchItemSelected, andDirection: .fromScreen)
        collectionView.fromScreenFinishedCallback = {
            self.view.backgroundColor = .clear
            guard let selectedIndexPath = self.selectedIndexPath else { return }
            guard let selectedCell = self.collectionView.cellForItem(at: selectedIndexPath) as? SearchItemCell, let watchItem = selectedCell.watchItem else { return }
            
            parent?.addItemAfterSearch(watchItem)
        }
    }
}
