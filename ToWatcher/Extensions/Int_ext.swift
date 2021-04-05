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
        let minsCount = Double(self).truncatingRemainder(dividingBy: 60)
        let hoursCount = (Double(self) - minsCount) / 60
        let hours = NSLocalizedString("text_hours_short", comment: "Abbreviation of hour")
        let mins = NSLocalizedString("text_minutes_short", comment: "Abbreviation of minutes")
        return "\(Int(hoursCount)) \(hours) \(Int(minsCount)) \(mins)"
    }
}
