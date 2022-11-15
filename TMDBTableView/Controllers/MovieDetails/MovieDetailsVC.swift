//
//  MovieDetailsVC.swift
//  TMDBTableView
//
//  Created by qbuser on 10/11/22.
//

import UIKit

class MovieDetailsVC: UIViewController {
    
    // MARK: - Properties
    private let movie: Movie
    private let detailsView: MovieDetailsView
    
    // MARK: - Lifecycle
    init(movie: Movie, detailsView: MovieDetailsView = MovieDetailsView()) {
        self.movie = movie
        self.detailsView = detailsView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailsView
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
    }
    
    deinit {
        print("MovieDetailsVC deinit")
    }
    
}


// MARK: - UI Configuration
extension MovieDetailsVC {
    func configureNavBar() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.isTranslucent = true
            navigationItem.largeTitleDisplayMode = .never
        }
        navigationItem.title = movie.title
    }
}
