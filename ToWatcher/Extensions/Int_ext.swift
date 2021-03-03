//
//  Int_ext.swift
//  ToWatcher
//
//  Created by Alex Delin on 16.02.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Foundation

extension Int {
    func hoursMins() -> String {
        let mins = Double(self).truncatingRemainder(dividingBy: 60)
        let hours = (Double(self) - mins) / 60
        return "\(Int(hours)) ч \(Int(mins)) мин"
    }
}
