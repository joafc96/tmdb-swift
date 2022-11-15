//
//  MainCoordinator.swift
//  TMDBTableView
//
//  Created by qbuser on 10/11/22.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()
    weak var finishDelegate: CoordinatorFinishDelegate?
    internal let navigationController: UINavigationController
    internal var defaultImageServiceProvider: ImageServiceProvider?
    internal var type: CoordinatorType { .app }
    
    // MARK: - Lifecycle
    /// Instantiate the application coordinator.
    /// - Parameters:
    /// - navigationController: The root navigation controller.
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    convenience init(navigationController: UINavigationController, defaultImageServiceProvider: ImageServiceProvider) {
        self.init(navigationController: navigationController)
        self.defaultImageServiceProvider = defaultImageServiceProvider
    }
    
    // MARK: - Entry point
    /// Launch initial state of the app.
    func start() {
        guard let defaultImageServiceProvider = defaultImageServiceProvider else { fatalError("Image service provider is not initialized yet.") }
        
        let vc = MovieListTableVC(
            viewModel: MovieViewModel(
                apiService: TMDBMovieRepository(),
                imageAPIService: TMDBImageRepository(
                    imageServiceProvider: defaultImageServiceProvider
                )
            )
        )
        
        vc.coordinatorDelegate = self
        navigationController.setViewControllers([vc], animated: false)
    }
}

// MARK: - MovieList Table View Delegate
extension AppCoordinator : MovieListTableViewControllerCoordinatorDelegate {
    func navigateToMovieDetails(for movie: Movie) {
        let detailsVC = MovieDetailsVC(movie: movie)
        navigationController.pushViewController(detailsVC, animated: true)
    }
}

