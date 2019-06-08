//
//  AppStyle.swift
//  ToWatcher
//
//  Created by Alex Delin on 29/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

struct AppStyle {
    //    view sizes
    static var topSafeArea: CGFloat = 0
    static var bottomSafeArea: CGFloat = 0
    static var menuViewHeight: CGFloat = 88
    static var arrowViewHeight: CGFloat = 18
    static var menuBarFullHeight = topSafeArea + menuViewHeight + arrowViewHeight
    static var itemHeight: CGFloat = round(UIScreen.main.bounds.width * 0.42)
    static var itemCornerRadius: CGFloat = itemHeight * 0.42
    static var floatActionButtonHeight: CGFloat = 56
    static var watchItemInfoPadding: CGFloat = 10
    static var watchItemInfoLineSpacing: CGFloat = 4
    static var searchTextFieldHeight: CGFloat = 40
    static var searchTextFieldTopPadding: CGFloat = 50
    static var searchTextFieldLeftRightPadding: CGFloat = round(itemHeight / 3)
    
    //    font
    static var appFontNameBold = "Montserrat-Bold"
    
    //    font sizes
    static var menuItemFontSize: CGFloat = 11
    static var watchItemInfoLocalTitleFontSize: CGFloat = round(itemHeight / 7.5)
    static var watchItemInfoOriginalTitleFontSize: CGFloat = round(itemHeight / 12.5)
    static var searchTextFieldFontSize: CGFloat = watchItemInfoOriginalTitleFontSize
    
    //    colors
    static var menuBarBGColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static var menuItemActiveTextColor: UIColor = #colorLiteral(red: 0.2156862745, green: 0.2784313725, blue: 0.3137254902, alpha: 1)
    static var menuItemInactiveTextColor: UIColor = #colorLiteral(red: 0.7529411765, green: 0.7725490196, blue: 0.7843137255, alpha: 1)
    static var floatActionButtonBGColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static var floatActionButtonIconAddColor: UIColor = #colorLiteral(red: 0, green: 0.5529411765, blue: 0.8352941176, alpha: 1)
    static var floatActionButtonIconCloseColor: UIColor = #colorLiteral(red: 0.2156862745, green: 0.2784313725, blue: 0.3137254902, alpha: 1)
    static var watchItemInfoLocalTitleTextColor: UIColor = menuItemActiveTextColor
    static var watchItemInfoOriginalTitleTextColor: UIColor = #colorLiteral(red: 0.6588235294, green: 0.6862745098, blue: 0.7019607843, alpha: 1)
    static var searchTextFieldTintColor: UIColor = menuItemActiveTextColor
    
    //    images
    static var menuItemToWatchImage: UIImage = #imageLiteral(resourceName: "menu-item-to-watch")
    static var menuItemWatchedImage: UIImage = #imageLiteral(resourceName: "menu-item-watched")
    static var arrowViewImage: UIImage = #imageLiteral(resourceName: "arrow-down")
    static var floatActionBarIconImage: UIImage = #imageLiteral(resourceName: "plus")
}
