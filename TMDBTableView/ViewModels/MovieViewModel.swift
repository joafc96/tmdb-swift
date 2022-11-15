//
//  MovieViewModel.swift
//  TMDBTableView
//
//  Created by qbuser on 01/10/22.
//

import Foundation
import CoreGraphics

protocol MovieListViewModelProtocol {
    var viewState: Observable<PaginationViewState<Movie>> { get }
    var movies: [Movie] { get }
    
    func canFetch() -> Bool
    
    func loadData(for movieType: MovieType, isRefresh: Bool )
    func loadImage(for path: String, completion: @escaping (Data?) -> Void)
}

final class MovieViewModel: MovieListViewModelProtocol {
    // MARK: - Dependencies
    private let apiService: MovieRepository
    private let imageService: ImageRepository
    
    // MARK: - Reactive properties
    private (set) var viewState: Observable<PaginationViewState<Movie>> = Observable(.uninitialized)
    
    // MARK: - Computed properties
    private var currentPage: Int {
        return viewState.value.currentPage
    }
    
    var movies: [Movie] {
        return viewState.value.currentEntities
    }
    
    // MARK: - Initializers
    init(apiService: MovieRepository, imageAPIService: ImageRepository) {
        self.apiService = apiService
        self.imageService = imageAPIService
    }
    
    deinit {
        print("MovieViewModel deinit")
    }
    
    // MARK: - Networking
    func loadData(for movieType: MovieType,  isRefresh: Bool = false) {
        if !isRefresh {
            viewState.value = (viewState.value == .uninitialized)
            ? .initialFetching
            : .moreFetching(currentEntities: movies, next: currentPage + 1);
        } else {
            viewState.value = .refreshing
        }
        
        /*
         At first when the method is called the state will be initial fetching so current page will be 1, and then after more fetching is called the page is incremented by 1 each time. And finally at the time the fetched view state is called we set the incremented page as current page.
         */
        apiService.getMovies(for: movieType, page: currentPage) { [weak self]  result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let movieResult):
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    strongSelf.viewState.value = strongSelf.processMovieResult(currentPage: strongSelf.currentPage, currentMovies: strongSelf.movies, fetchedMovies: movieResult.movies)
                })
  
            case .failure(let error):
                strongSelf.viewState.value = .error(error)
            }
        }
    }
    
    func loadImage(for path: String, completion: @escaping (Data?) -> Void) {
        imageService.fetchImage(for: path, with: ImageQuality.posterMedium) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func canFetch() -> Bool {
        if (viewState.value == .initialFetching || viewState.value == .moreFetching(currentEntities: movies, next: viewState.value.currentPage)) {
            return false
        }
        return true
    }
    
    // MARK: - Private
    private func processMovieResult(currentPage: Int, currentMovies: [Movie], fetchedMovies movies: [Movie]) -> PaginationViewState<Movie> {
        var allMovies = currentPage == 1 ? [] : currentMovies
        allMovies.append(contentsOf: movies)
        guard !allMovies.isEmpty else { return .empty }
        return .fetched(allMovies, current: currentPage)
    }
}
