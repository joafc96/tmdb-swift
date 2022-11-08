//
//  MovieRepository.swift
//  TMDBTableView
//
//  Created by qbuser on 08/11/22.
//

import Foundation

protocol MovieRepository: Networkable {
    func getMovies(for type: MovieType, page: Int, completion: @escaping RepoCallback<MovieResults>)
}
