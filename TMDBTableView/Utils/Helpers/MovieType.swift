//
//  MovieType.swift
//  TMDBTableView
//
//  Created by qbuser on 13/10/22.
//

import Foundation

enum MovieType: String {
    case popular = "popular"
    case upcoming = "upcoming"
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    
    var localized: String {
        switch self {
        case .popular:
            return L10n.movieTypePopular
        case .upcoming:
            return L10n.movieTypeUpcoming
        case .nowPlaying:
            return L10n.movieTypeNowPlaying
        case .topRated:
            return L10n.movieTypeTopRated
        }
    }
}
