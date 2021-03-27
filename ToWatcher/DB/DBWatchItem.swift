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
    dynamic var backdropURLString: String? = nil
    dynamic var localTitle: String = ""
    dynamic var originalTitle: String = ""
    dynamic var year: String = ""
    dynamic var score: Double = 0.0
    dynamic var overview: String = ""
    dynamic var genres: List<DBGenre> = List<DBGenre>()
    dynamic var duration: String = ""
    dynamic var cast: List<DBPerson> = List<DBPerson>()
    dynamic var director: DBPerson? = nil
    dynamic var type: String = ""
    dynamic var dateAdded: Date? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(_ item: WatchItem) {
        self.init()
        self.id = item.id
        self.backdropURLString = item.backdropURL?.absoluteString
        self.localTitle = item.localTitle
        self.originalTitle = item.originalTitle
        self.year = item.year
        self.score = item.score
        self.overview = item.overview
        
        let genres = List<DBGenre>()
        genres.append(objectsIn: item.genres.map { DBGenre($0) })
        self.genres = genres
        
        self.duration = item.duration
        
        let cast = List<DBPerson>()
        cast.append(objectsIn: item.cast.compactMap { DBPerson($0) })
        self.cast = cast
        
        self.director = DBPerson(item.director)
        self.type = item.type.rawValue
        self.dateAdded = Date()
    }
}
