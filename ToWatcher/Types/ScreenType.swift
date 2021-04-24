//
//  ScreenType.swift
//  ToWatcher
//
//  Created by Alex Delin on 24.04.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Foundation

enum ScreenType {
    case toWatch
    case watched
    case search
    case info
    case `default`
}

protocol Screen {
    var screen: ScreenType { get }
}
