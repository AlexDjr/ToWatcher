//
//  WatchItemCellState.swift
//  ToWatcher
//
//  Created by Alex Delin on 04.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import Foundation

enum WatchItemCellState: Equatable {
    case enabled
    case disabled
    case editing(WatchItemEditState)
}
