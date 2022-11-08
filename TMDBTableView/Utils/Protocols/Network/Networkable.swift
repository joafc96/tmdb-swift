//
//  NetworkService.swift
//  TMDBTableView
//
//  Created by qbuser on 13/10/22.
//

import Foundation

// Based on Tiny Networking by Objc.io
// https://talk.objc.io/episodes/S01E133-tiny-networking-library-revisited

protocol Networkable {
    var session: URLSession { get }    

    func load<Object>(
        _ resource: Resource<Object>,
        completion: @escaping (Result<Object, Error>) -> Void
    ) -> URLSessionDataTask?
}


//MARK: - Default Implementation
extension Networkable {
    /// Load a resource and return the parsed object(s) in a closure.
    ///
    /// - Parameters:
    ///   - resource: The resource to parse.
    ///   - completion: Contains the loaded object.
    /// - Returns: The optional data task so it can be cancelled or stored.
    func load<Object>(
        _ resource: Resource<Object>,
        completion: @escaping (Result<Object, Error>) -> Void
    ) -> URLSessionDataTask? {
        let task = session.dataTask(with: resource.request) { data, response, error in
            // Error
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(TMDBError.unknownError))
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(TMDBError.unexpectedResponse))
                return
            }
            guard let object = data.flatMap(resource.parse) else {
                completion(.failure(TMDBError.parseError))
                return
            }
            
            // Success
            completion(.success(object))
        }

        return task
    }
}
