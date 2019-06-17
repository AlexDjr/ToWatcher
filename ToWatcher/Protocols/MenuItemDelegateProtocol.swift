//
//  MenuItemDelegateProtocol.swift
//  ToWatcher
//
//  Created by Alex Delin on 16/06/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import Foundation

protocol MenuItemDelegateProtocol: class {
    func didSelectMenuItem(at indexPath: IndexPath)
}
