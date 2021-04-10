//
//  Date_ext.swift
//  ToWatcher
//
//  Created by Alex Delin on 10.04.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Foundation

extension Optional where Wrapped == Date {
    func year() -> String {
        guard let self = self else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: self)
        return year
    }
}
