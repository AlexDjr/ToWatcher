//
//  DBManager.swift
//  ToWatcher
//
//  Created by Alex Delin on 17.03.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    static let shared = DBManager()
    
    fileprivate let db = try! Realm()
    
    private lazy var toWatchItems = getWatchItemsFromDB(.toWatch)
    private lazy var watchedItems = getWatchItemsFromDB(.watched)
    
    // MARK: - Public methods
    func getWatchItems(_ type: WatchType) -> [WatchItem] {
        switch type {
        case .toWatch: return toWatchItems.map { WatchItem.init($0) }
        case .watched: return watchedItems.map { WatchItem.init($0) }
        default: break
        }
        
        return []
    }
    
    func getRecentWatchItems(_ type: WatchType) -> [WatchItem] {
        return getWatchItems(type).filter { $0.releaseDate != nil && $0.releaseDate!.daysBetweenDate(Date()) < 90 }
    }
    
    func insert(_ item: WatchItem) {
        try! db.write {
            let dbItem = DBWatchItem(item)
            db.add(dbItem, update: .modified)
        }
    }
    
    func update(_ item: WatchItem) {
        try! db.write {
            guard let dbItem = db.object(ofType: DBWatchItem.self, forPrimaryKey: item.id) else { return }
            dbItem.update(with: item)
        }
    }
    
    func delete(_ item: WatchItem) {
        guard let dbItem = db.object(ofType: DBWatchItem.self, forPrimaryKey: item.id) else { return }
        let castToDelete = getCastToDelete(dbItem)
        try! db.write {
            db.delete(castToDelete)
            db.delete(dbItem)
        }
    }
    
    // MARK: - Private methods
    private func getWatchItemsFromDB(_ type: WatchType) -> Results<DBWatchItem> {
        return db.objects(DBWatchItem.self).filter ("type = '\(type.rawValue)'").sorted(byKeyPath: "dateAdded", ascending: false)
    }
    
    private func getCastToDelete(_ dbItem: DBWatchItem) -> [DBPerson] {
        var cast = Array(dbItem.cast)
        
        if let director = dbItem.director {
            cast.append(director)
        }
        
        return cast.filter { $0.watchItemsAsActor.count + $0.watchItemsAsDirector.count == 1 }
    }
    
    fileprivate func getIfExists(_ person: Person?) -> DBPerson? {
        if let person = person, let dbPerson = db.object(ofType: DBPerson.self, forPrimaryKey: person.id) {
            return dbPerson
        } else {
            return DBPerson(person)
        }
    }
    
    fileprivate func getIfExists(_ genre: Genre) -> DBGenre {
        if let dbGenre = db.object(ofType: DBGenre.self, forPrimaryKey: genre.id) {
            return dbGenre
        } else {
            return DBGenre(genre)
        }
    }
}

fileprivate extension DBWatchItem {
    func update(with item: WatchItem) {
        self.backdropURLString = item.backdropURL?.absoluteString
        self.localTitle = item.localTitle
        self.originalTitle = item.originalTitle
        self.releaseDate = item.releaseDate
        self.score = item.score
        self.overview = item.overview
        self.duration = item.duration
        self.director = DBManager.shared.getIfExists(item.director)
        self.type = item.type.rawValue
        
        let cast = item.cast.compactMap { DBManager.shared.getIfExists($0) }
        let genres = item.genres.map { DBManager.shared.getIfExists($0) }
        
        self.cast.removeAll()
        self.cast.append(objectsIn: cast)
        
        self.genres.removeAll()
        self.genres.append(objectsIn: genres)
    }
}
