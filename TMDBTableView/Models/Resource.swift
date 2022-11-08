//
//  Resource.swift
//  TMDBTableView
//
//  Created by qbuser on 13/10/22.
//
// Based on Tiny Networking by Objc.io
// https://talk.objc.io/episodes/S01E133-tiny-networking-library-revisited

import Foundation

struct Resource<Object> {
    var request: URLRequest
    let parse: (Data) -> Object?
}

//The HttpMethod enum is generic over Data so that the .post case can hold data for the request's body.
enum HttpMethod<Body> {
    case get
    case post(Body)
    
    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}

/// Creates a new resource for `Decodable` objects that can be parsed automatically.
extension Resource where Object: Decodable {
    //MARK: GET
    /// - Parameter url: The URL to create the request.
    /// - Parameter parse: The parse method is provided here for changes in strategies of the decoder
    ///  like date decoding strategy / convert from snake case etc.
    init(get url: URL, parse: @escaping (Data) -> Object?) {
        self.request = URLRequest(url: url)
        self.parse = parse
    }
    /// - Parameter url: The URL to create the request.
    init(get url: URL) {
        self.request = URLRequest(url: url)
        self.parse = { data in
            return try? JSONDecoder().decode(Object.self, from: data)
        }
    }
    
    //MARK: POST
    /// - Parameter url: The URL to create the request.
    /// - Parameter method: The method of the request.
    init<Body: Encodable>(url: URL, method: HttpMethod<Body>) {
        request = URLRequest(url: url)
        request.httpMethod = method.method
        
        switch method{
        case .get: ()
        case .post(let body):
            self.request.httpBody = try! JSONEncoder().encode(body)
        }
        
        self.parse = { data in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try? decoder.decode(Object.self, from: data)
        }
    }
}

/// Creates a new resource for `DATA` objects that can be parsed automatically.
extension Resource where Object: DataProtocol {
    // MARK: FILE
    /// - Parameter request: The request to load a resource from.
    init(getImage url: URL) {
        request = URLRequest(url: url)

        self.parse = { data in
            data as? Object
        }
    }
}
