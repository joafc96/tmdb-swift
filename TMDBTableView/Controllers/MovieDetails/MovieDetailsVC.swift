//
//  MovieDetailsVC.swift
//  TMDBTableView
//
//  Created by qbuser on 10/11/22.
//

import UIKit

class MovieDetailsVC: UIViewController {
    private let detailsView: MovieDetailsView

    init(detailsView: MovieDetailsView = MovieDetailsView()) {
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
    }
    
    deinit {
        print("MovieDetailsVC is deinitialized")
    }
}
