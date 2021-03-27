//
//  Person.swift
//  ToWatcher
//
//  Created by Alex Delin on 21.03.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Foundation

struct Person: Decodable {
    var id: Int
    var name: String
    var originalName: String
    var job: String
    var photoURL: URL?
    var watchItems: [WatchItem]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName
        case profilePath
        case job
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let imageBaseURL = "https://image.tmdb.org/t/p/"
        let backdropSize = "w185"
        
        
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        originalName = try container.decodeIfPresent(String.self, forKey: .originalName) ?? ""
        job = try container.decodeIfPresent(String.self, forKey: .job) ?? ""
        let profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath) ?? ""
        
        let photoURLString = profilePath != "" ? "\(imageBaseURL)\(backdropSize)\(profilePath)" : ""
        photoURL = URL(string: photoURLString)
    }
    
    init(id: Int, name: String, originalName: String, job: String, photoURL: URL?) {
        self.id = id
        self.name = name
        self.originalName = originalName
        self.job = job
        self.photoURL = photoURL
    }
    
    init?(_ dbPerson: DBPerson?) {
        guard let dbPerson = dbPerson else { return nil }
        self.init(id: dbPerson.id,
                  name: dbPerson.name,
                  originalName: dbPerson.originalName,
                  job: dbPerson.job,
                  photoURL: URL(string: dbPerson.photoURLString ?? ""))
    }
}
