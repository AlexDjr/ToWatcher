//
//  DBGenre.swift
//  ToWatcher
//
//  Created by Alex Delin on 21.03.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class DBGenre: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(_ genre: Genre) {
        self.init()
        self.id = genre.id
        self.name = genre.name
    }
}
