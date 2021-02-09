//
//  NetworkManager.swift
//  ToWatcher
//
//  Created by Alex Delin on 11.02.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Foundation
import Alamofire
import KeychainAccess

class NetworkManager {
    static let shared = NetworkManager()
    
    // MARK: - Public methods
    func search(_ searchString: String, completion: @escaping (Result<[WatchItem], Error>) -> ()) {
        let token = (try? Keychain().getString("token")) ?? ""
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        var parameters: [String: Any] = [:]
        parameters["language"] = "ru-RU"
        parameters["page"] = 1
        parameters["query"] = searchString
        
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        
        let baseURL = "https://image.tmdb.org/t/p/"
        let backdropSize = "w780"
        
        AF.request("https://api.themoviedb.org/3/search/movie", parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { response in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else { return }
                    let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                    let movies = searchResponse.results
                   
                    let watchItems = movies.map { WatchItem(imageURL: URL(string: "\(baseURL)\(backdropSize)\($0.backdropPath ?? "")")!,
                                                            localTitle: $0.title,
                                                            originalTitle: $0.originalTitle,
                                                            year: $0.releaseDate.year()) }
                    completion(.success(watchItems))
                    
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
        
    }
}
