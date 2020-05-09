//
//  AppStyle.swift
//  ToWatcher
//
//  Created by Alex Delin on 29/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

struct AppStyle {
    // MARK: - view sizes
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    static var topSafeAreaHeight: CGFloat = 0
    static var bottomSafeAreaHeight: CGFloat = 0
    static let menuViewHeight: CGFloat = 88
    static let arrowViewHeight: CGFloat = 18
    static let menuBarFullHeight = topSafeAreaHeight + menuViewHeight + arrowViewHeight
    static let itemHeight: CGFloat = round(screenWidth * 0.42)
    static let itemCornerRadius: CGFloat = itemHeight * 0.42
    static let floatActionButtonHeight: CGFloat = 56
    static let watchItemInfoPadding: CGFloat = 10
    static let watchItemInfoLineSpacing: CGFloat = 4
    static let searchTextFieldHeight: CGFloat = 40
    static let searchTextFieldTopPadding: CGFloat = 50
    static let searchTextFieldLeftRightPadding: CGFloat = round(itemHeight / 3)
    static let itemRoundCorners: UIRectCorner = [.topRight, .bottomLeft]
    
    // WatchItemCell edit mode
    static let watchItemEditActionViewWidth: CGFloat = 100.0
    static let watchItemEditRemoveWidth: CGFloat = 200.0
    static let watchItemEditHideActionViewGap: CGFloat = 25.0
    
    static let watchItemEditStickToFrameGap: CGFloat = 10.0
    static let watchItemEditEndMovingViewGap: CGFloat = 25.0
    
    static let watchItemEditActionViewIconSize = CGSize(width: 44.0, height: 44.0)
    
    // MARK: - font
    static var appFontNameBold = "Montserrat-Bold"
    
    // MARK: - font sizes
    static let menuItemFontSize: CGFloat = 11
    static let watchItemInfoLocalTitleFontSize: CGFloat = round(itemHeight / 7.5)
    static let watchItemInfoOriginalTitleFontSize: CGFloat = round(itemHeight / 12.5)
    static let searchTextFieldFontSize: CGFloat = watchItemInfoOriginalTitleFontSize
    
    // MARK: - colors
    static let menuBarBGColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let menuItemActiveTextColor: UIColor = #colorLiteral(red: 0.2156862745, green: 0.2784313725, blue: 0.3137254902, alpha: 1)
    static let menuItemInactiveTextColor: UIColor = #colorLiteral(red: 0.7529411765, green: 0.7725490196, blue: 0.7843137255, alpha: 1)
    static let floatActionButtonBGColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let floatActionButtonIconAddColor: UIColor = #colorLiteral(red: 0, green: 0.5529411765, blue: 0.8352941176, alpha: 1)
    static let floatActionButtonIconCloseColor: UIColor = #colorLiteral(red: 0.2156862745, green: 0.2784313725, blue: 0.3137254902, alpha: 1)
    static let watchItemInfoLocalTitleTextColor: UIColor = menuItemActiveTextColor
    static let watchItemInfoOriginalTitleTextColor: UIColor = #colorLiteral(red: 0.6588235294, green: 0.6862745098, blue: 0.7019607843, alpha: 1)
    static let searchTextFieldTintColor: UIColor = menuItemActiveTextColor
    
    // MARK: - images
    static let menuItemToWatchImage: UIImage = #imageLiteral(resourceName: "menu-item-to-watch")
    static let menuItemWatchedImage: UIImage = #imageLiteral(resourceName: "menu-item-watched")
    static let arrowViewImage: UIImage = #imageLiteral(resourceName: "arrow-down")
    static let floatActionBarIconImage: UIImage = #imageLiteral(resourceName: "plus")
    static let watchItemActionWatchedImage: UIImage = #imageLiteral(resourceName: "action_view_watched")
    static let watchItemActionDeleteImage: UIImage = #imageLiteral(resourceName: "action_view_delete")
    
    // MARK: - animations
    static let animationDuration = 0.4
}
