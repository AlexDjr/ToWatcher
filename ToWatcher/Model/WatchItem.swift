//
//  WatchItem.swift
//  ToWatcher
//
//  Created by Alex Delin on 10.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

class WatchItem: Equatable {
    var id: Int
    var imageURL: URL
    var localTitle: String
    var originalTitle: String
    var year: String
    var score: Double
    var type: WatchType
    
    init(id: Int, imageURL: URL, localTitle: String, originalTitle: String, year: String, score: Double, type: WatchType) {
        self.id = id
        self.imageURL = imageURL
        self.localTitle = localTitle
        self.originalTitle = originalTitle
        self.year = year
        self.score = score
        self.type = type
    }
    
    convenience init(_ dbItem: DBWatchItem) {
        self.init(id: dbItem.id, imageURL: URL(string: dbItem.imageURLString)!, localTitle: dbItem.localTitle, originalTitle: dbItem.originalTitle, year: dbItem.year, score: dbItem.score, type: WatchType.init(rawValue: dbItem.type)!)
    }
    
    static func == (lhs: WatchItem, rhs: WatchItem) -> Bool {
        return lhs.localTitle == rhs.localTitle && lhs.originalTitle == rhs.originalTitle && lhs.id == rhs.id
    }
}
