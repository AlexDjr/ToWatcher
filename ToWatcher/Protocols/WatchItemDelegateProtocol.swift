//
//  WatchItemDelegateProtocol.swift
//  ToWatcher
//
//  Created by Alex Delin on 29/04/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import Foundation

protocol WatchItemDelegateProtocol: class {
    func didSelectItem()
    func didFinishMoveItemsBack()
}
