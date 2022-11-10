//
//  ViewController.swift
//  TMDBTableView
//
//  Created by qbuser on 01/10/22.
//

import UIKit

protocol MovieListTableViewControllerDelegate: AnyObject {
    func showDetails(for movie: Movie)
}

class MovieListTableVC: UIViewController {
    private let movieType: MovieType
    weak var delegate: MovieListTableViewControllerDelegate?
    
    // MARK: - Dependencies
    private let viewModel: MovieViewModel
    private let movieView: MovieListView
    private let tableProvider: MovieListTableProvider = MovieListTableProvider()
    
    // MARK: - Lifecycle
    init(movieType: MovieType = MovieType.nowPlaying,
         movieView: MovieListView = MovieListView(),
         viewModel: MovieViewModel) {
        self.viewModel = viewModel
        self.movieType = movieType
        self.movieView = movieView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        /* Implement and setup the view in load view.
         loadView() gets called before viewDidLoad().
         loadView() sets up the initial view of view controller.
         Do not call super when overriding loadView().
         No need to call super.loadView() as apple does not recommend it and there are no code to be executed before.
         */
        view = movieView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableViewDelegates()
        configureRefreshControlTarget()
        configureBindables()
        
        viewModel.loadData(for: movieType)
    }
    
    deinit {
        print("MovieTableViewVC is deinitialized")
    }
    
    //MARK:- Pull to refresh
    @objc
    private func onRefresh(_ sender: UIRefreshControl) {
        viewModel.loadData(for: movieType, isRefresh: true)
        movieView.refreshControl.endRefreshing(with: 0.5)
    }
}

// MARK: - UI Configurations
extension MovieListTableVC {
    private func configureTableViewDelegates() {
        tableProvider.delegate = self
        
        movieView.movieTableView.delegate = tableProvider
        movieView.movieTableView.dataSource = tableProvider
    }
    
    private func configureNavBar() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.hidesBarsOnSwipe = true
            //navigationController?.hidesBarsOnTap = true
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
        }
        navigationItem.title = movieType.localized
    }
    
    private func configureRefreshControlTarget() {
        movieView.refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
    }
    
    private func getUIImage(for data: Data?) -> UIImage? {
        guard let data = data else {
            return UIImage(systemName: "photo")
        }
        return UIImage(data: data)
    }
}

//MARK: - Reactive Behaviour
extension MovieListTableVC {
    private func configureBindables() {
        /*
         Retain Cycle: [view controller -> view model -> bind  -> self (view controller)].
         
         To break the retain cycle we can unowned and not weak because,
         we want the corresponding viewmodel to co exist with the
         life of view controller and also using weak has performance issues in the long run
         (Only if it doesn't have async operations like network requests).
         (But here as we are using network requests and if the view controller can go out of scope so weak is used).
         */
        
        viewModel.viewState.bind { [weak self] (state: PaginationViewState) in
            guard let strongSelf = self else { return }
            strongSelf.configureView(withState: state)
        }
    }
}

//MARK: - Configure View According to State
extension MovieListTableVC {
    private func configureView(withState state: PaginationViewState<Movie>) {
        switch state {
        case .uninitialized, .refreshing:
            break
            
        case .initialFetching:
            movieView.initialActivityView.startAnimating()
            
        case .moreFetching:
            // Creates a frame for the loading more activity view and assign it to the view
            let loadingMoreActivityFrame = CGRect(x: 0, y: movieView.movieTableView.contentSize.height, width: movieView.movieTableView.contentSize.width, height: InfiniteScrollActivityView.defaultHeight)
            
            movieView.loadingMoreActivityView.frame = loadingMoreActivityFrame
            movieView.loadingMoreActivityView.startAnimating()
            
        case .fetched:

            if (movieView.initialActivityView.isAnimating) {
                movieView.initialActivityView.stopAnimating()
            }
            
            if (movieView.loadingMoreActivityView.isAnimating()) {
                movieView.loadingMoreActivityView.stopAnimating()
            }
            
            // update values and reload table view
            tableProvider.movies = viewModel.movies
            movieView.movieTableView.reloadData()
            
        case .empty:
            break
            
        case .error(let error):
            if (movieView.initialActivityView.isAnimating) {
                movieView.initialActivityView.stopAnimating()
            }
            
            if (movieView.loadingMoreActivityView.isAnimating()) {
                movieView.loadingMoreActivityView.stopAnimating()
            }
            
            guard let error = error as? TMDBError else {
                print(error.localizedDescription)
                return
            }
            print(error.localized)
            break
        }
    }
}

// MARK: - MovieListTableProvider Delegates
extension MovieListTableVC: MovieListTableProviderDelegate {
    func canFetchMovie() -> Bool {
        return viewModel.canFetch()
    }
    
    func didSelect(movie: Movie) {
        // Segue to newVC

        // let newVC = newVC()
        //present(newVC, animated: true)
        //newVC.modalPresentationStyle = .fullScreen
        //newVC.modalTransitionStyle = .flipHorizontal
        //navigationController?.pushViewController(newVc, animated: true)
        delegate?.showDetails(for: movie)
    }
    
    func loadNextPage() {
        viewModel.loadData(for: movieType)
    }
}
