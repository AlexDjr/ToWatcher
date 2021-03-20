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

typealias SearchResult = (items: [WatchItem], totalPages: Int)

class NetworkManager {
    static let shared = NetworkManager()
    
    private static let token = (try? Keychain().getString("token")) ?? ""
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let headers: HTTPHeaders = [
        "Authorization": "Bearer \(NetworkManager.token)",
        "Accept": "application/json"
    ]
    
    private var parameters: [String: Any] = ["language":"ru-RU"]
    
    private let decoder: JSONDecoder = {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private var searchRequests: [DataRequest] = []
    
    // MARK: - Public methods
    func search(_ searchString: String, page: Int, completion: @escaping (Result<SearchResult, Error>) -> ()) {
        parameters["page"] = page
        parameters["query"] = searchString
        
        let imageBaseURL = "https://image.tmdb.org/t/p/"
        let backdropSize = "w780"
        
        let request = AF.request("\(baseURL)/search/movie", parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success:
                    do {
                        guard let data = response.data else { return }
                        let searchResponse = try self.decoder.decode(SearchResponse.self, from: data)
                        let totalPages = searchResponse.totalPages
                        let movies = searchResponse.results
                        
                        let watchItems = movies.map { WatchItem(id: $0.id, imageURL: URL(string: "\(imageBaseURL)\(backdropSize)\($0.backdropPath ?? "")")!,
                                                                localTitle: $0.localTitle,
                                                                originalTitle: $0.originalTitle,
                                                                year: $0.year,
                                                                score: $0.score,
                                                                type: .default) }
                        completion(.success((watchItems, totalPages)))
                        
                    } catch let error {
                        completion(.failure(error))
                    }
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        
        searchRequests.append(request)
    }
    
    func getMovieInfo(_ id: Int, completion: @escaping (Result<Movie, Error>) -> ()) {
        parameters["append_to_response"] = "credits"
        
        AF.request("\(baseURL)/movie/\(id)", parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success:
                    do {
                        guard let data = response.data else { return }
                        let movie = try self.decoder.decode(Movie.self, from: data)
                        
                        completion(.success((movie)))
                        
                    } catch let error {
                        completion(.failure(error))
                    }
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
    
    func cancelSearchRequests() {
        searchRequests.forEach { $0.cancel() }
        searchRequests.removeAll()
    }
}
