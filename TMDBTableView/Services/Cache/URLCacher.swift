//
//  File.swift
//  TMDBTableView
//
//  Created by qbuser on 14/10/22.
//

import Foundation

final public class URLCacher {
    private let urlCache: URLCache
    
    init(urlCache: URLCache){
        self.urlCache = urlCache
    }
    
    func insert(with data: CachedURLResponse, for request: URLRequest) {
        self.urlCache.storeCachedResponse(data, for: request)
    }
    
    func value(for request: URLRequest) -> CachedURLResponse? {
        return self.urlCache.cachedResponse(for: request)
    }
    
    func removeValue(for request: URLRequest) {
        self.urlCache.removeCachedResponse(for: request)
    }
    
    func clear() {
        self.urlCache.removeAllCachedResponses()
    }
    
    deinit {
        print("URLCacher is deinitialized")
    }
}
