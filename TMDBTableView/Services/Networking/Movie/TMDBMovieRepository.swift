//
//  MovieNetworkService.swift
//  TMDBTableView
//
//  Created by qbuser on 13/10/22.
//

import Foundation

final class TMDBMovieRepository: MovieRepository {
    let session = URLSession.shared
    private var dataTask: URLSessionDataTask?

    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func getMovies(for type: MovieType, page: Int, completion: @escaping RepoCallback<MovieResults>) {
        guard let url = Endpoint.movies(path: type.rawValue, page: page).url else {
            return completion(.failure(TMDBError.invalidUrl))
        }
        let resource  = Resource<MovieResults>(get: url, parse: { [weak self] data in
            return try? self?.decoder.decode(MovieResults.self, from: data)
        })
        
        dataTask = load(resource, completion: completion)
        dataTask?.resume()
    }
    
    func cancelUpdate() {
        dataTask?.cancel()
    }
    
    deinit {
        print("TMDB Movie Repo service is deinitialized")
    }
}
