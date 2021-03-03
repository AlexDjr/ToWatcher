//
//  SearchMovie.swift
//  ToWatcher
//
//  Created by Alex Delin on 09.02.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Foundation

struct SearchMovie: Decodable {
    var id: Int
    var backdropPath: String?
//    var genreIds: [Int]
    var originalTitle: String
    var title: String
    var overview: String?
    var voteAverage: Double?
    var releaseDate: String?
}

struct SearchResponse: Decodable {
    var totalPages: Int
    var results: [SearchMovie]
}
