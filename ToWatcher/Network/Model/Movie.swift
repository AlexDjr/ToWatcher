//
//  Movie.swift
//  ToWatcher
//
//  Created by Alex Delin on 16.02.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    var id: Int
    var backdropPath: String
    var originalTitle: String
    var localTitle: String
    var overview: String
    var score: Double?
    var year: String
    var genres: [String]
    var duration: String
    var cast: [Person]
    var director: Person?
    
    enum CodingKeys: String, CodingKey {
        case id
        case backdropPath
        case originalTitle
        case localTitle = "title"
        case overview
        case score = "voteAverage"
        case year = "releaseDate"
        case genres
        case duration = "runtime"
        case cast = "credits"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) ?? ""
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle) ?? ""
        localTitle = try container.decodeIfPresent(String.self, forKey: .localTitle) ?? ""
        overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        score = try container.decodeIfPresent(Double.self, forKey: .score) ?? 0.0
        year = try container.decodeIfPresent(String.self, forKey: .year).year()
        genres = (try container.decodeIfPresent([Genre].self, forKey: .genres))?.map { $0.name } ?? []
        
        let durationInt = try container.decodeIfPresent(Int.self, forKey: .duration) ?? 0
        duration = durationInt != 0 ? "\(durationInt.hoursMins())" : ""
        
        let credits = try container.decodeIfPresent(Credits.self, forKey: .cast)
        let fullCast = credits?.cast ?? []
        let fullCrew = credits?.crew ?? []
        cast = Array(fullCast.prefix(5))
        director = fullCrew.first { $0.job == "Director" }
    }
}

struct Genre: Decodable {
    var id: Int
    var name: String
}

struct Credits: Decodable {
    var cast: [Person]?
    var crew: [Person]?
}

struct Person: Decodable {
    var name: String
    var originalName: String
    var job: String
    var imageURL: URL
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case originalName
        case profilePath
        case job
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let imageBaseURL = "https://image.tmdb.org/t/p/"
        let backdropSize = "w185"
        
        
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        originalName = try container.decodeIfPresent(String.self, forKey: .originalName) ?? ""
        job = try container.decodeIfPresent(String.self, forKey: .job) ?? ""
        let profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath) ?? ""
        imageURL = URL(string: "\(imageBaseURL)\(backdropSize)\(profilePath)")!
    }
}
