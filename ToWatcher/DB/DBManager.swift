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
    
    private let db = try! Realm()
    
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
    
    func save(_ item: WatchItem) {
        let dbItem = DBWatchItem(item)
        try! db.write {
            db.add(dbItem, update: .modified)
        }
    }
    
    func delete(_ item: WatchItem) {
        guard let dbItem = db.object(ofType: DBWatchItem.self, forPrimaryKey: item.id) else { return }
        try! db.write {
            db.delete(dbItem)
        }
    }
    
    // MARK: - Private methods
    private func getWatchItemsFromDB(_ type: WatchType) -> Results<DBWatchItem> {
        return db.objects(DBWatchItem.self).filter ("type = '\(type.rawValue)'").sorted(byKeyPath: "dateAdded", ascending: false)
    }
    
}
