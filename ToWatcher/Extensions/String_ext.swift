//
//  String_ext.swift
//  ToWatcher
//
//  Created by Alex Delin on 11.02.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    func toDate() -> Date? {
        guard let self = self else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: self) else { return nil }
        return date
    }
}
