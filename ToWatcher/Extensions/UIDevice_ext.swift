//
//  UIDevice_ext.swift
//  ToWatcher
//
//  Created by Alex Delin on 17.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

extension UIDevice {
    enum ScreenType {
        case iPhones_320
        case iPhones_375
        case iPhone_414
    }
    
    var screenType: ScreenType {
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth < 375.0 {
            return .iPhones_320
        } else if screenWidth >= 375.0 && screenWidth < 414.0 {
            return .iPhones_375
        } else {
            return .iPhone_414
        }
    }
}
