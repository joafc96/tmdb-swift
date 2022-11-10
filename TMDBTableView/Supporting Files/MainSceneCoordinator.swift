//
//  MainCoordinator.swift
//  TMDBTableView
//
//  Created by qbuser on 10/11/22.
//

import UIKit

final class MainSceneCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()
    weak var delegate: CoordinatorDelegate?
    private let navigationController: UINavigationController
    private let defaultImageServiceProvider: ImageServiceProvider
    
    // MARK: - Lifecycle
    /// Instantiate the application coordinator.
    /// - Parameters:
    /// - navigationController: The root navigation controller.
    init(navigationController: UINavigationController, defaultImageServiceProvider: ImageServiceProvider) {
        self.navigationController = navigationController
        self.defaultImageServiceProvider = defaultImageServiceProvider
    }
    
    // MARK: - Entry point
    /// Launch initial state of the app.
    func start() {
        let vc = MovieListTableVC(
            viewModel: MovieViewModel(
                apiService: TMDBMovieRepository(),
                imageAPIService: TMDBImageRepository(
                    imageServiceProvider: defaultImageServiceProvider
                )
            )
        )
        
        vc.delegate = self
        navigationController.setViewControllers([vc], animated: false)
    }
}

// MARK: - MovieList Table View Delegate
extension MainSceneCoordinator : MovieListTableViewControllerDelegate {
    func showDetails(for movie: Movie) {
        let detailsVC = MovieDetailsVC()
        navigationController.pushViewController(detailsVC, animated: true)
    }
}
