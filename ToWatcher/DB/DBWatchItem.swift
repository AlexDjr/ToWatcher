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
    dynamic var backdropURLString: String = ""
    dynamic var localTitle: String = ""
    dynamic var originalTitle: String = ""
    dynamic var year: String = ""
    dynamic var score: Double = 0.0
    dynamic var overview: String = ""
    dynamic var genres: List<String> = List<String>()
    dynamic var duration: String = ""
    dynamic var cast: List<DBPerson> = List<DBPerson>()
    dynamic var director: DBPerson? = nil
    dynamic var type: String = ""
    dynamic var dateAdded = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(_ item: WatchItem) {
        self.init()
        self.id = item.id
        self.backdropURLString = item.backdropURL.absoluteString
        self.localTitle = item.localTitle
        self.originalTitle = item.originalTitle
        self.year = item.year
        self.score = item.score
        self.overview = item.overview
        
        let genres = List<String>()
        genres.append(objectsIn: item.genres)
        self.genres = genres
        
        self.duration = item.duration
        
        let cast = List<DBPerson>()
        cast.append(objectsIn: item.cast.compactMap { DBPerson($0) })
        self.cast = cast
        
        self.director = DBPerson(item.director)
        self.type = item.type.rawValue
    }
}

@objcMembers class DBPerson: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var originalName: String = ""
    dynamic var job: String = ""
    dynamic var photoURLString: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init?(_ person: Person?) {
        guard let person = person else { return nil }
        
        self.init()
        self.id = person.id
        self.name = person.name
        self.originalName = person.originalName
        self.job = person.job
        self.photoURLString = person.photoURL.absoluteString
    }
}
