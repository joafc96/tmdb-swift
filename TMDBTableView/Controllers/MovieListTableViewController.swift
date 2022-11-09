//
//  ViewController.swift
//  TMDBTableView
//
//  Created by qbuser on 01/10/22.
//

import UIKit

class MovieListTableViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: MovieViewModel
    private let movieListView: MovieListView = MovieListView()
    private let movieType: MovieType
    
    var tableProvider: MovieListTableProvider!
    
    
    // MARK: - Lifecycle
    init(viewModel: MovieViewModel, movieType: MovieType = MovieType.nowPlaying) {
        self.viewModel = viewModel
        self.movieType = movieType
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
        view = movieListView
        configureNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureTableViewDelegates()
        configureRefreshControlTarget()
        
        configureBindables()
        viewModel.fetchMovies(for: movieType)
    }
    
    deinit {
        print("MovieUITableViewVC is deinitialized")
    }
    
    //MARK:- Pull to refresh
    @objc
    private func onRefresh(_ sender: UIRefreshControl) {
        viewModel.fetchMovies(for: movieType, isRefresh: true)
        movieListView.refreshControl.endRefreshing(with: 0.5)
    }
}

// MARK: - UI Configurations
extension MovieListTableViewController {
    private func configureTableViewDelegates() {
        
        tableProvider = MovieListTableProvider()
        tableProvider.delegate = self
        
        movieListView.movieTableView.delegate = tableProvider
        movieListView.movieTableView.dataSource = tableProvider
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
        movieListView.refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
    }
    
    private func getUIImage(for data: Data?) -> UIImage? {
        guard let data = data else {
            return UIImage(systemName: "photo")
        }
        return UIImage(data: data)
    }
}

//MARK: - Reactive Behaviour
extension MovieListTableViewController {
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
extension MovieListTableViewController {
    private func configureView(withState state: PaginationViewState<Movie>) {
        switch state {
        case .uninitialized, .refreshing:
            break
            
        case .initialFetching:
            movieListView.initialActivityView.startAnimating()
            
        case .moreFetching:
            // Creates a frame for the loading more activity view and assign it to the view
            let loadingMoreActivityFrame = CGRect(x: 0, y: movieListView.movieTableView.contentSize.height, width: movieListView.movieTableView.contentSize.width, height: InfiniteScrollActivityView.defaultHeight)
            
            movieListView.loadingMoreActivityView.frame = loadingMoreActivityFrame
            movieListView.loadingMoreActivityView.startAnimating()
            
        case .fetched:
            tableProvider.movies = viewModel.movies

            if (movieListView.initialActivityView.isAnimating) {
                movieListView.initialActivityView.stopAnimating()
            }
            
            if (movieListView.loadingMoreActivityView.isAnimating()) {
                movieListView.loadingMoreActivityView.stopAnimating()
            }
            movieListView.movieTableView.reloadData()
            
        case .empty:
            break
            
        case .error(let error):
            if (movieListView.initialActivityView.isAnimating) {
                movieListView.initialActivityView.stopAnimating()
            }
            
            if (movieListView.loadingMoreActivityView.isAnimating()) {
                movieListView.loadingMoreActivityView.stopAnimating()
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
extension MovieListTableViewController: MovieListTableProviderDelegate {
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
    }
    
    func loadNextPage() {
        viewModel.fetchMovies(for: movieType)
    }
}


//MARK: - DataSource Delegate
//extension MovieListTableViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.movies.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = movieCell(with: tableView, indexPath: indexPath)
//        return cell
//    }
//
//    func movieCell(with tableView: UITableView, indexPath: IndexPath) -> MovieTableViewCell {
//        let cell: MovieTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
//        if let movie = viewModel.movieForRow(at: indexPath) {
//            cell.configureCell(with: movie)
//        }
//        return cell
//    }
//}

//MARK: Table View Delegate
//extension MovieListTableViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        // Segue to newVC
//
//        // let newVC = newVC()
//        //present(newVC, animated: true)
//        //newVC.modalPresentationStyle = .fullScreen
//        //newVC.modalTransitionStyle = .flipHorizontal
//        //navigationController?.pushViewController(newVc, animated: true)
//    }
//}


//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // Checks whether a movie table view cell is available for dequeing and also if movies list is empty or not and if it is a default table view cell is returned
//        guard let movieCell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.dequeIdentifier, for: indexPath) as? MovieTableViewCell,
//                !viewModel.movies.isEmpty else {
//            return UITableViewCell()
//        }
//
//        let movie = viewModel.movieForRow(at: indexPath)
//
//        movieCell.title = movie.title
//        movieCell.overview = movie.overview
//
//        /* while dequeing cells the old stale images are the ones which get replaced with the new downloaded ones,
//         so we assign the cell image as nil */
//        movieCell.poster = nil
//
//        /*
//         Assign the movie id from server as a unique id for the cell
//         */
//        let representedIdentifier = movie.id
//        movieCell.representedIdentifier = representedIdentifier!
//
//        if let posterPath = movie.posterPath {
//            viewModel.loadImage(for: posterPath) { [weak self] (data: Data?)  in
//                DispatchQueue.main.async {
//                    /* if the network connection is slow or if it takes time to download the image, the image downloaded can get placed into the wrong cell while dequeing the cells, so here we assign the cell a unique identifier and later on when the image is downloaded we check equality of both the identifiers before assigning the image */
//
//                    guard movieCell.representedIdentifier == representedIdentifier else { return }
//                    movieCell.poster = self?.getUIImage(for: data)
//                }
//            }
//        }
//        return movieCell
//    }



//MARK: - Infinite Scrolling (ScrollView Delegate)
//extension MovieListTableViewController {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let canFetch = viewModel.canFetch()
//        if(!canFetch) {
//            return
//        }
//
//        // Calculates where the user is in the y-axis
//        let offsetY = scrollView.contentOffset.y
//        let scrollViewContentHeight = scrollView.contentSize.height
//        let scrollViewBoundsHeight = scrollView.bounds.size.height
//        let scrollOffsetThreshold = scrollViewContentHeight - scrollViewBoundsHeight
//
//        if (offsetY > scrollOffsetThreshold && movieListView.movieTableView.isDragging) {
//            viewModel.fetchMovies(for: movieType)
//        }
//    }
//}
