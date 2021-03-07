//
//  UIScrollView_ext.swift
//  ToWatcher
//
//  Created by Alex Delin on 08.03.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import UIKit

extension UIScrollView {
    static func standart() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }
}


let rr = UIScrollView.standart()
