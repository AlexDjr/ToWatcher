//
//  WatchItemEditProtocol.swift
//  ToWatcher
//
//  Created by Alex Delin on 05.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

protocol WatchItemEditProtocol: class {
    func didRemoveItem(_ cell: UICollectionViewCell, withType type: WatchItemEditState)
}
