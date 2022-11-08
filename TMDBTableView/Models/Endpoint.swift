//
//  Endpoint.swift
//  TMDBTableView
//
//  Created by qbuser on 02/10/22.
//

import Foundation


struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            return nil
        }
        
        return url
    }
    
    var imageUrl: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "image.tmdb.org"
        components.path = "/t/p/" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            return nil
        }
        
        return url
    }
    
    static func movies(path: String, page: Int = 1) -> Self {
        Endpoint(path: "movie/\(path)", queryItems: [
            URLQueryItem(name: "api_key", value: "cfe422613b250f702980a3bbf9e90716"),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "language", value: "en-US"),
        ])
    }
    
    static func posterImage(path: String, quality: String?) -> Self {
        if let quality = quality {
            return Endpoint(path: "\(quality)\(path)")
        } else {
            return Endpoint(path: path)
        }
    }
}
