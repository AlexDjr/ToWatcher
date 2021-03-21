//
//  DBPerson.swift
//  ToWatcher
//
//  Created by Alex Delin on 21.03.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class DBPerson: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var originalName: String = ""
    dynamic var job: String = ""
    dynamic var photoURLString: String? = nil
    
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
        self.photoURLString = person.photoURL?.absoluteString
    }
}
