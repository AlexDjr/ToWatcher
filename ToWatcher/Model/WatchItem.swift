//
//  WatchItem.swift
//  ToWatcher
//
//  Created by Alex Delin on 10.05.2020.
//  Copyright © 2020 Alex Delin. All rights reserved.
//

import UIKit

class WatchItem: Equatable {
    var id: Int
    var backdropURL: URL?
    var localTitle: String
    var originalTitle: String
    var year: String
    var score: Double
    var overview: String
    var genres: [Genre]
    var duration: String
    var cast: [Person]
    var director: Person?
    var type: WatchType
    
    init(id: Int,
         backdropURL: URL?,
         localTitle: String,
         originalTitle: String,
         year: String,
         score: Double,
         overview: String = "",
         genres: [Genre] = [],
         duration: String = "",
         cast: [Person] = [],
         director: Person? = nil,
         type: WatchType) {
        self.id = id
        self.backdropURL = backdropURL
        self.localTitle = localTitle
        self.originalTitle = originalTitle
        self.year = year
        self.score = score
        self.type = type
        self.overview = overview
        self.genres = genres
        self.duration = duration
        self.cast = cast
        self.director = director
    }
    
    convenience init(_ dbItem: DBWatchItem) {
        self.init(id: dbItem.id,
                  backdropURL: URL(string: dbItem.backdropURLString ?? ""),
                  localTitle: dbItem.localTitle,
                  originalTitle: dbItem.originalTitle,
                  year: dbItem.year,
                  score: dbItem.score,
                  overview: dbItem.overview,
                  genres: Array(dbItem.genres.map { Genre($0) }),
                  duration: dbItem.duration,
                  cast: Array(dbItem.cast.compactMap { Person($0) }),
                  director: Person(dbItem.director),
                  type: WatchType.init(rawValue: dbItem.type)!)
    }
    
    static func == (lhs: WatchItem, rhs: WatchItem) -> Bool {
        return lhs.localTitle == rhs.localTitle && lhs.originalTitle == rhs.originalTitle && lhs.id == rhs.id
    }
}

extension WatchItem {
    func addMovieInfo(_ movie: Movie) {
        self.overview = movie.overview
        self.genres = movie.genres
        self.duration = movie.duration
        self.cast = movie.cast
        self.director = movie.director
    }
    
    var isMovieInfoAdded: Bool { overview != "" || !genres.isEmpty || duration != "" || !cast.isEmpty || director != nil }
    
    var genresString: String {
        guard !genres.isEmpty else { return "---" }
        return genres.map {$0.name}.joined(separator: " • ")
    }
}
