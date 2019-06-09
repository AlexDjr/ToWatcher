//
//  ViewController.swift
//  ToWatcher
//
//  Created by Alex Delin on 17/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class HomeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, WatchItemDelegateProtocol {

    var containerView: UICollectionView!
    var floatActionButton: FloatActionButton = {
       let floatActionButton = FloatActionButton()
        return floatActionButton
    }()
    let menuBar: MenuBar = {
        let menuBar = MenuBar()
        return menuBar
    }()
    
    private lazy var toWatchController: ToWatchController = {
        var viewController = ToWatchController()
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
        setupFloatActionButton()
        floatActionButton.addTarget(self, action: #selector(pressFloatActionButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTopAndBottomSafeArea()
    }
    
    
    //   MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = containerView.dequeueReusableCell(withReuseIdentifier: ContainerCell.reuseIdentifier, for: indexPath) as! ContainerCell
        
        switch indexPath.item {
        case 0: cell.hostedView = toWatchController.view
        default: break
        }
        
//        cell.contentView.backgroundColor = .blue
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
        changeFloatActionButton(.close)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.menuBar.transform = CGAffineTransform.init(translationX: 0, y: -AppStyle.menuBarFullHeight)
        }, completion: nil)
    }
    
    func didFinishMoveItemsBack() {
        moveMenuBarBackToDefaultPosition()
    }

    
    //    MARK: - Methods
    private func setupTopAndBottomSafeArea() {
        if #available(iOS 11.0, *) {
            AppStyle.topSafeArea = view.safeAreaInsets.top
            AppStyle.bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            AppStyle.topSafeArea = topLayoutGuide.length
            AppStyle.bottomSafeArea = bottomLayoutGuide.length
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
//        containerView.topAnchor.constraint(equalTo: menuBar.bottomAnchor).isActive = true
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
        floatActionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -AppStyle.bottomSafeArea - 10).isActive = true
        floatActionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        floatActionButton.heightAnchor.constraint(equalToConstant: AppStyle.floatActionButtonHeight).isActive = true
        floatActionButton.widthAnchor.constraint(equalToConstant: AppStyle.floatActionButtonHeight).isActive = true
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        viewController.didMove(toParent: self)
    }
    
    private func moveMenuBarBackToDefaultPosition() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.menuBar.transform = .identity
        }, completion: nil)
    }
    
    @objc private func pressFloatActionButton() {
        switch self.floatActionButton.actionState {
        case .add:
            self.changeFloatActionButton(.close)
            menuBar.isHidden = true
            toWatchController.openSearch()
        case .close:
            self.changeFloatActionButton(.add)
            menuBar.isHidden = false
            toWatchController.moveItemsBackToScreen()
        }
    }
    
    private func changeFloatActionButton(_ state: FloatActionButton.ActionState) {
        UIView.animate(withDuration: 0.5) {
            self.floatActionButton.change(state)
        }
    }
   
}

