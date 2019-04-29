//
//  ViewController.swift
//  ToWatcher
//
//  Created by Alex Delin on 17/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class HomeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ToWatchDelegateProtocol {

    var containerView: UICollectionView!
    
    var floatActionButton: FloatActionButton!
    let menuBar: MenuBar = {
       let menuBar = MenuBar()
        return menuBar
    }()
    
    private lazy var toWatchController: ToWatchController = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        
        var viewController = ToWatchController(collectionViewLayout: layout)
        
        viewController.delegate = self
        
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupContainerView()
        setupMenuBar()
        setFloatActionButton()
        floatActionButton.addTarget(self, action: #selector(pressFloatActionButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            AppStyle.topSafeArea = view.safeAreaInsets.top
            AppStyle.bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            AppStyle.topSafeArea = topLayoutGuide.length
            AppStyle.bottomSafeArea = bottomLayoutGuide.length
        }
    }
    
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = containerView.dequeueReusableCell(withReuseIdentifier: ContainerCell.reuseIdentifier, for: indexPath) as! ContainerCell
        
        switch indexPath.item {
        case 0: cell.hostedView = toWatchController.collectionView
        default: break
        }
        
        cell.contentView.backgroundColor = .clear
//        cell.contentView.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
//        cell.contentView.layer.borderWidth = 2.0
        return cell
    }
    
    //    MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    //    MARK: - ToWatchDelegateProtocol
    func didSelectItem() {
        view.bringSubviewToFront(containerView)
        view.bringSubviewToFront(floatActionButton)
        
        changeFloatActionButton(.close)
    }

    
    //    MARK: - Methods
    fileprivate func setupContainerView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        containerView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        containerView.isPagingEnabled = true
        containerView.showsHorizontalScrollIndicator = false
        containerView.backgroundColor = .clear
        containerView.dataSource = self
        containerView.delegate = self
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.topAnchor.constraint(equalTo: menuBar.bottomAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        containerView.register(ContainerCell.self, forCellWithReuseIdentifier: ContainerCell.reuseIdentifier)
    }
    
    fileprivate func setupMenuBar() {
        view.addSubview(menuBar)
        
        menuBar.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: AppStyle.topSafeArea + 88 + 18).isActive = true
        menuBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    fileprivate func setFloatActionButton() {
        floatActionButton = FloatActionButton(frame: CGRect.zero)
        
        view.addSubview(floatActionButton)
        floatActionButton.translatesAutoresizingMaskIntoConstraints = false
        floatActionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -AppStyle.bottomSafeArea - 10).isActive = true
        floatActionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        floatActionButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        floatActionButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    @objc private func pressFloatActionButton() {
        switch self.floatActionButton.actionState {
        case .add:
            self.changeFloatActionButton(.close)
        case .close:
            self.changeFloatActionButton(.add)
        }
        toWatchController.moveItemsBack()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.view.bringSubviewToFront(self.menuBar)
        }
    }
    
    private func changeFloatActionButton(_ state: FloatActionButton.ActionState) {
        UIView.animate(withDuration: 0.8) {
            self.floatActionButton.change(state)
        }
    }
   
}

