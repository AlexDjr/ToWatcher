//
//  Genre.swift
//  ToWatcher
//
//  Created by Alex Delin on 21.03.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Foundation

struct Genre: Decodable {
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init(_ dbGenre: DBGenre) {
        self.init(id: dbGenre.id, name: dbGenre.name)
    }
}
