//
//  URLCachedImageService.swift
//  TMDBTableView
//
//  Created by qbuser on 20/10/22.
//

import Foundation

typealias URLCachedNetworkableImage = ImageNetworkable &  URLCachable

final class URLCachedImageService: URLCachedNetworkableImage {
    let urlCache: URLCacher
    let session: URLSession
    
    init(urlCache: URLCacher, session: URLSession = URLSession.shared){
        self.urlCache = urlCache
        self.session = session
    }
    
    func loadImage(_ resource: Resource<Data>, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
        if let cachedImageResponse = self.urlCache.value(for: resource.request) {
            completion(.success(cachedImageResponse.data))
            return nil
        }
        return load(resource, completion: completion)
    }
    
    //MARK: - Load Method from Network Service (Overridden)
    // The load function from network service is overridden here as we require the response to create cached url response.
    private func load(
        _ resource: Resource<Data>,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask? {
       
        let task = session.dataTask(with: resource.request) { (data, response, error) in
           // Error
           guard error == nil else {
               completion(.failure(error!))
               return
           }
           guard let response = response as? HTTPURLResponse else {
               completion(.failure(TMDBError.unknownError))
               return
           }
           guard (200...299).contains(response.statusCode) else {
               completion(.failure(TMDBError.unexpectedResponse))
               return
           }
            guard let data = data.flatMap(resource.parse) else {
               completion(.failure(TMDBError.parseError))
               return
           }
           
           // save the data in cache after downloading from network
           let cache = CachedURLResponse(response: response, data: data)
           self.urlCache.insert(with: cache, for: resource.request)
           
           // Success
            completion(.success(cache.data))
       }
       return task
   }
}
