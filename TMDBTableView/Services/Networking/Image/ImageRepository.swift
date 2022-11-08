//
//  ImageRepository.swift
//  TMDBTableView
//
//  Created by qbuser on 08/11/22.
//

import Foundation

protocol ImageRepository {
    func fetchImage(for path: String, with quality: ImageQuality?, completion: @escaping RepoCallback<Data>)
}
