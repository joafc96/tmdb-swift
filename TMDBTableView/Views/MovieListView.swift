//
//  File.swift
//  TMDBTableView
//
//  Created by qbuser on 01/11/22.
//

import UIKit

class MovieListView: UIView {
    
    public lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        
        return refreshControl
    }()
    
    public lazy var initialActivityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.hidesWhenStopped = true
        
        return activityView
    }()
    
    public lazy var loadingMoreActivityView: InfiniteScrollActivityView = {
        let activityView = InfiniteScrollActivityView(frame: .zero)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.isHidden = true

        return activityView
    }()
    
    public lazy var movieTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.nameOfClass)
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        configureSubViews()
        configureConstraints()
    }
    
    private func configureSubViews() {
        /*
         (For auto collapse/expand of nav bar to work)
         Make sure that addSubview(tableView) is placed before others addSubview(someview).
         Scrollview has to be first subview for auto collapse/expand to work.
         TableView of its container should be at the top of ViewController's view hierarchy. Otherwise it won't work.
         */
        addSubview(movieTableView)
        movieTableView.addSubview(loadingMoreActivityView)

        addSubview(initialActivityView)
        
        if #available(iOS 10.0, *) {
            movieTableView.refreshControl = refreshControl
        } else {
            movieTableView.addSubview(refreshControl)
        }
    }
    
    private func configureConstraints() {
        initialActivityView.centerInSuperView()
        movieTableView.fillInSuperView()
    }
}
