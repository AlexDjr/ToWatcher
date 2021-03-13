//
//  UIColor_ext.swift
//  ToWatcher
//
//  Created by Alex Delin on 13.03.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import UIKit

extension UIColor {
    
    var darker: UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        
        guard self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) else { return .gray }
        
        let adjusted = b * 0.7
        
        return UIColor(hue: h, saturation: s, brightness: adjusted, alpha: a)
    }
}
