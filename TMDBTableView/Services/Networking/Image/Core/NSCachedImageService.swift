//
//  NSCachedImageService.swift
//  TMDBTableView
//
//  Created by qbuser on 19/10/22.
//

import Foundation

typealias ImageNSCache = NSCacher<ImageCacheKey, Data>
typealias NSCachedNetworkableImage = ImageNetworkable & ImageNSCachable

final class NSCachedImageService: NSCachedNetworkableImage {
    internal let session: URLSession
    internal let nsCache: ImageNSCache
    
    init(nsCache: ImageNSCache, session: URLSession = URLSession.shared) {
        self.nsCache = nsCache
        self.session = session
    }
    
    func loadImage(
        _ resource: Resource<Data>,
        completion: @escaping (Result<Data, Error>) -> Void
    )
    -> URLSessionDataTask? {
        // Unwrap url, because we need it a few times
        guard let url = resource.request.url else {
            completion(.failure(TMDBError.invalidUrl))
            return nil
        }
        
        let reference = ImageCacheKey(url: url)
        
        if let cachedImageData = nsCache[reference] {
            completion(.success(cachedImageData))
            return nil
        }
        
        // Returns a url session data task.
        return load(resource) { [weak self] result in
            switch result {
            case .success(let data):
                self?.nsCache.insert(data, forKey: reference)
                
                completion(.success(data))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
