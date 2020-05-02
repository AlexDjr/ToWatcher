//
//  PanGestureRecognizer_ext.swift
//  ToWatcher
//
//  Created by Alex Delin on 02.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

extension UIPanGestureRecognizer {
    enum GestureDirection {
        case left
        case right
    }
    var direction: GestureDirection {
        return self.velocity(in: self.view).x > 0 ? .right : .left
    }
}
