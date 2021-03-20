//
//  DBWatchItem.swift
//  ToWatcher
//
//  Created by Alex Delin on 15.03.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class DBWatchItem: Object {
    dynamic var id: Int = 0
    dynamic var imageURLString: String = ""
    dynamic var localTitle: String = ""
    dynamic var originalTitle: String = ""
    dynamic var year: String = ""
    dynamic var score: Double = 0.0
    dynamic var type: String = ""
    dynamic var dateAdded = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(_ item: WatchItem) {
        self.init()
        self.id = item.id
        self.imageURLString = item.imageURL.absoluteString
        self.localTitle = item.localTitle
        self.originalTitle = item.originalTitle
        self.year = item.year
        self.score = item.score
        self.type = item.type.rawValue
    }
}
