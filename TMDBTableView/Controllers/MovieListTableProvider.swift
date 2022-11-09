//
//  MovieListTableProvider.swift
//  TMDBTableView
//
//  Created by qbuser on 08/11/22.
//

import UIKit

protocol MovieListTableProviderDelegate: AnyObject {
    func canFetchMovie() -> Bool
    func didSelect(movie: Movie)
    func loadNextPage()
}

class MovieListTableProvider: NSObject {
    var movies: [Movie] = []
    weak var delegate: MovieListTableProviderDelegate?
}

// MARK: - UITableViewDataSource
extension MovieListTableProvider: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieCell(with: tableView, indexPath: indexPath)
        return cell
    }
    
    func movieCell(with tableView: UITableView, indexPath: IndexPath) -> MovieTableViewCell {
        let cell: MovieTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        let movie = movies[indexPath.row] 
        cell.configureCell(with: movie)
        return cell
    }

}

// MARK: - UITableViewDelegate
extension MovieListTableProvider: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        delegate?.didSelect(movie: movie)
    }
}


// MARK: - Infinite Scrolling (ScrollView Delegate)
extension MovieListTableProvider {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let canFetch = delegate?.canFetchMovie()
        guard let canFetch = canFetch else { return }
        
        if(!canFetch) {
            return
        }
        
        // Calculates where the user is in the y-axis
        let offsetY = scrollView.contentOffset.y
        let scrollViewContentHeight = scrollView.contentSize.height
        let scrollViewBoundsHeight = scrollView.bounds.size.height
        let scrollOffsetThreshold = scrollViewContentHeight - scrollViewBoundsHeight
        
        if (offsetY > scrollOffsetThreshold) {
            delegate?.loadNextPage()
        }
    }
}
