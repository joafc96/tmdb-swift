//
//  ImageFetching.swift
//  TMDBTableView
//
//  Created by qbuser on 19/10/22.
//

import Foundation

protocol ImageNetworkable: Networkable {
    func loadImage(
        _ resource: Resource<Data>,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask?
}
