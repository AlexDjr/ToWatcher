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
    static let itemCornerRadiusCoeff: CGFloat = 0.42
    static let itemShadowRadiusCoeff: CGFloat = 1 / 34.77
    static let itemsLineSpacing: CGFloat = round(AppStyle.itemHeight / 20)
    static let floatActionButtonHeight: CGFloat = 56.0
    static let floatActionButtonPadding: CGFloat = 10.0
    static let personImageViewHeight: CGFloat = 56.0
    static let actorViewWidth: CGFloat = 95.0
    static let directorViewWidth: CGFloat = 96.0
    static let searchLoaderHeight: CGFloat = 30.0
    static let alertViewHeight: CGFloat = topSafeAreaHeight + 60.0
    static let alertOKButtonWidth: CGFloat = 60.0
    static let alertViewPadding: CGFloat = 11.0
    
    static var alertOKButtonCornerRadius: CGFloat {
        switch UIDevice.current.screenType {
        case .iPhones_320: return 12.5
        case .iPhones_375: return 13.5
        case .iPhone_414: return 14.0
        }
    }
    
    static var alertImageHeight: CGFloat {
        switch UIDevice.current.screenType {
        case .iPhones_320: return 20.0
        default: return 26.0
        }
    }
    
    static var bigScoreViewHeight: CGFloat {
        switch UIDevice.current.screenType {
        case .iPhones_320: return 50.0
        default: return 56.0
        }
    }
    
    static var smallScoreViewHeight: CGFloat {
        switch UIDevice.current.screenType {
        case .iPhones_320: return 20.0
        default: return 22.0
        }
    }
    
    static let watchItemInfoPadding: CGFloat = 10
    static let watchItemInfoLineSpacing: CGFloat = 4
    static let searchViewHeight: CGFloat = 40
    static let searchViewTopPadding: CGFloat = 70
    static let searchViewBottomPadding: CGFloat = 30
    static let searchViewLeftRightPadding: CGFloat = round(itemHeight / 3)
    static let searchViewContainerHeight = searchViewHeight + searchViewTopPadding + searchViewBottomPadding
    static let itemRoundCorners: UIRectCorner = [.topRight, .bottomLeft]
    
    static var watchItemLabelsPadding: CGFloat {
        switch UIDevice.current.screenType {
        case .iPhones_320: return 10.0
        case .iPhones_375: return 17.0
        case .iPhone_414: return 20.0
        }
    }
    
    static var watchItemOriginalTitleRightPadding: CGFloat {
        switch UIDevice.current.screenType {
        case .iPhones_320: return 34.0
        case .iPhones_375: return 36.0
        case .iPhone_414: return 38.0
        }
    }
    
    static var watchItemYearBottomPadding: CGFloat {
        switch UIDevice.current.screenType {
        case .iPhones_320: return 32.0
        case .iPhones_375: return 42.0
        case .iPhone_414: return 46.0
        }
    }
    
    
    // WatchItemCell edit mode
    static let watchItemEditActionViewWidth: CGFloat = 100.0
    static let watchItemEditRemoveWidth: CGFloat = 200.0
    static let watchItemEditHideActionViewGap: CGFloat = 25.0
    
    static let watchItemEditStickToFrameGap: CGFloat = 10.0
    static let watchItemEditEndMovingViewGap: CGFloat = 25.0
    static let watchItemEditWatchedShouldStopGap: CGFloat = 20.0
    
    static let watchItemEditActionViewIconSize = CGSize(width: 44.0, height: 44.0)
    
    static let watchItemEditMinimizeScale = (AppStyle.screenWidth - itemsLineSpacing * 2) / AppStyle.screenWidth
    static private let resultItemHeight = (AppStyle.itemHeight * watchItemEditMinimizeScale * 1000).rounded() / 1000
    static let watchItemEditTranslationY = itemsLineSpacing - (AppStyle.itemHeight - resultItemHeight) / 2
    
    // SearchItemCell
    static let searchItemLeftRightPadding: CGFloat = itemsLineSpacing
    static let searchItemMainViewHeight: CGFloat = round(((screenWidth - searchItemLeftRightPadding * 3) / 2 - 22.0) * 0.42)
    static let searchItemMainViewWidth: CGFloat = round(searchItemMainViewHeight / 0.42)
    
    static var searchItemLocalTitleFontSize: CGFloat {
        switch UIDevice.current.screenType {
        case .iPhones_320: return 10.0
        case .iPhones_375: return 12.0
        case .iPhone_414: return 13.0
        }
    }
    
    static var searchItemOriginalTitleFontSize: CGFloat {
        switch UIDevice.current.screenType {
        case .iPhones_320: return 8.0
        case .iPhones_375: return 10.0
        case .iPhone_414: return 11.0
        }
    }
    
    static var searchItemYearFontSize: CGFloat {
        switch UIDevice.current.screenType {
        case .iPhones_320: return 9.0
        case .iPhones_375: return 12.0
        case .iPhone_414: return 13.0
        }
    }
    
    // MARK: - font
    static var appFontNameBold = "Montserrat-Bold"
    static var appFontNameSemiBold = "Montserrat-SemiBold"
    static var appFontNameRegular = "Montserrat-Regular"
    
    // MARK: - font sizes
    static let menuItemFontSize: CGFloat = 11
    static let menuItemCounterFont: UIFont = UIFont(name: AppStyle.appFontNameBold, size: 16.0)!
    static let watchItemInfoLocalTitleFontSize: CGFloat = round(itemHeight / 7.5)
    static let watchItemInfoLabelsFontSize: CGFloat = round(itemHeight / 11.5)
    static let searchTextFieldFontSize: CGFloat = watchItemInfoLabelsFontSize
    static let bigScoreViewFontSize: CGFloat = 18
    static var smallScoreViewFontSize: CGFloat {
        switch UIDevice.current.screenType {
        case .iPhones_320: return 8
        default: return 9
        }
    }
    
    static var watchItemLocalTitleFontSize: CGFloat {
        switch UIDevice.current.screenType {
        case .iPhones_320: return 20.0
        case .iPhones_375: return 21.0
        case .iPhone_414: return 22.0
        }
    }
    
    static var watchItemOriginalTitleFontSize: CGFloat {
        switch UIDevice.current.screenType {
        case .iPhones_320: return 9.0
        case .iPhones_375: return 10.0
        case .iPhone_414: return 11.0
        }
    }
    
    static var watchItemYearFontSize: CGFloat {
        switch UIDevice.current.screenType {
        case .iPhones_320: return 17.0
        case .iPhones_375: return 19.0
        case .iPhone_414: return 20.0
        }
    }
    
    // MARK: - colors
    static let mainBGColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let menuItemActiveTextColor: UIColor = #colorLiteral(red: 0.2156862745, green: 0.2784313725, blue: 0.3137254902, alpha: 1)
    static let menuItemInactiveTextColor: UIColor = #colorLiteral(red: 0.7529411765, green: 0.7725490196, blue: 0.7843137255, alpha: 1)
    static let menuItemToWatchCounterColor: UIColor = #colorLiteral(red: 0, green: 0.5529411765, blue: 0.8352941176, alpha: 1)
    static let menuItemWatchedCounterColor: UIColor = #colorLiteral(red: 0.3647058824, green: 0.8274509804, blue: 0.6196078431, alpha: 1)
    static let floatActionButtonBGColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let floatActionButtonIconAddColor: UIColor = #colorLiteral(red: 0, green: 0.5529411765, blue: 0.8352941176, alpha: 1)
    static let floatActionButtonIconCloseColor: UIColor = #colorLiteral(red: 0.2156862745, green: 0.2784313725, blue: 0.3137254902, alpha: 1)
    static let watchItemInfoLabelsTextColor: UIColor = menuItemActiveTextColor
    static let watchItemInfoOriginalTitleTextColor: UIColor = #colorLiteral(red: 0.6588235294, green: 0.6862745098, blue: 0.7019607843, alpha: 1)
    static let searchViewTextColor: UIColor = menuItemActiveTextColor
    static let scoreHighColor: UIColor = menuItemWatchedCounterColor
    static let scoreMiddleColor: UIColor = #colorLiteral(red: 1, green: 0.7568627451, blue: 0, alpha: 1)
    static let scoreLowColor: UIColor = #colorLiteral(red: 0.7215686275, green: 0.04705882353, blue: 0.03529411765, alpha: 1)
    static let scoreBGColor: UIColor = #colorLiteral(red: 0.7529411765, green: 0.7725490196, blue: 0.7843137255, alpha: 0.5484267979)
    static let alertViewErrorColor: UIColor = #colorLiteral(red: 0.7215686275, green: 0.04705882353, blue: 0.03529411765, alpha: 1)
    static let alertViewWarningColor: UIColor = #colorLiteral(red: 1, green: 0.7568627451, blue: 0, alpha: 1)
    static let alertViewTextColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    // MARK: - images
    static let menuItemToWatchImage: UIImage = #imageLiteral(resourceName: "menu-item-to-watch")
    static let menuItemWatchedImage: UIImage = #imageLiteral(resourceName: "menu-item-watched")
    static let arrowViewImage: UIImage = #imageLiteral(resourceName: "arrow-down")
    static let floatActionBarIconImage: UIImage = #imageLiteral(resourceName: "plus")
    static let watchItemActionWatchedImage: UIImage = #imageLiteral(resourceName: "action_view_watched")
    static let watchItemActionDeleteImage: UIImage = #imageLiteral(resourceName: "action_view_delete")
    static let alertViewErrorImage: UIImage = #imageLiteral(resourceName: "error")
    static let alertViewWarningImage: UIImage = #imageLiteral(resourceName: "warning")
    
    // MARK: - animations
    static let animationDuration = 0.4
    static let alertViewAutoHidingInterval = 2.0
}
