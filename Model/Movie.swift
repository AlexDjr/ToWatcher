//
//  Movie.swift
//  ToWatcher
//
//  Created by Alex Delin on 09.02.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    var id: Int
    var backdropPath: String?
    var genreIds: [Int]
    var originalTitle: String
    var title: String
    var overview: String?
    var voteAverage: Double?
    var releaseDate: String?
}


struct Genre: Decodable {
    var id: Int
    var name: String
}

struct SearchResponse: Decodable {
    var page: Int
    var results: [Movie]
}
