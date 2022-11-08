//
//  ImageAPIServicee.swift
//  TMDBTableView
//
//  Created by qbuser on 13/10/22.
//

import Foundation

final class TMDBImageRepository: ImageRepository {
    
    private var imageServiceProvider: ImageServiceProvider
    private var dataTask: URLSessionDataTask?
    
    init(imageServiceProvider: ImageServiceProvider) {
        self.imageServiceProvider = imageServiceProvider
    }

    func fetchImage(for path: String, with quality: ImageQuality?, completion: @escaping RepoCallback<Data>) {
        guard let url = Endpoint.posterImage(path: path, quality: quality?.rawValue).imageUrl else {
            return completion(.failure(TMDBError.invalidUrl))
        }
        
        let resource  = Resource<Data>(getImage: url)
        
        dataTask = imageServiceProvider.urlCachedImageService.loadImage(resource, completion: completion)
        dataTask?.resume()
    }
    
    func cancelUpdate() {
        dataTask?.cancel()
    }
    
    deinit {
        print("Image API service is deinitialized")
    }
}
