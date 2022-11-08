//
//  ServicesProvider.swift
//  TMDBTableView
//
//  Created by qbuser on 14/10/22.
//

import Foundation

final class ImageServiceProvider {
    let nsCachedImageService: NSCachedImageService
    let urlCachedImageService: URLCachedImageService
    
    static func createDefaultProvider() -> Self {
        let urlCache = URLCache(
            memoryCapacity: 25 * 1024 * 1024,
            diskCapacity:  75 * 1024 * 1024
        )

        let urlCacher = URLCacher(urlCache: urlCache)
        let nsCacher = ImageNSCache()
        
        return Self.init(
            nsCachedImageService: NSCachedImageService(
                nsCache: nsCacher
            ),
            urlCachedImageService: URLCachedImageService(
                urlCache: urlCacher
            )
        )
    }
    
    required init(
        nsCachedImageService: NSCachedImageService,
        urlCachedImageService: URLCachedImageService
    ) {
        self.nsCachedImageService = nsCachedImageService
        self.urlCachedImageService = urlCachedImageService
    }
}
