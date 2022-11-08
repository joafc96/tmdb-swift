//
//  Movie.swift
//  TMDBTableView
//
//  Created by qbuser on 01/10/22.
//

import Foundation

struct MovieResults: Codable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case page, totalResults, totalPages
        case movies = "results"
    }
}

struct Movie: Codable, Equatable {
    let id: Int?
    let title: String?
    let overview: String?
    let releaseDate: String?
    let voteAverage: Double?
    let posterPath: String?
    let backdropPath: String?
    let runtime: Int?
    var duration: String? {
        get{
            if let runtime = runtime {
                return "\(runtime) mins"
            }
            return nil
        }
    }
}

extension Movie: CustomStringConvertible {
    var description: String {
        return "\(title ?? "movie") was released on \(releaseDate ?? Date.now.formatted()) with a rating of \(voteAverage ?? 0.0)."
    }
}
