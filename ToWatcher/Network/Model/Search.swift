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
    var localTitle: String
    var overview: String?
    var score: Double
    var year: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case backdropPath
        case originalTitle
        case localTitle = "title"
        case overview
        case score = "voteAverage"
        case year = "releaseDate"
    }

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle) ?? ""
        localTitle = try container.decodeIfPresent(String.self, forKey: .localTitle) ?? ""
        overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        score = try container.decodeIfPresent(Double.self, forKey: .score) ?? 0.0
        year = try container.decodeIfPresent(String.self, forKey: .year).year()
    }
}

struct SearchResponse: Decodable {
    var totalPages: Int
    var results: [SearchMovie]
}
