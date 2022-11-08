//
//  L10n.swift
//  TMDBTableView
//
//  Created by qbuser on 12/10/22.
//

import Foundation

final class L10n {
    //MARK: - Movie Type
    static let movieTypePopular = LocalizedString("movie-type.popular.title").resolve()
    static let movieTypeUpcoming = LocalizedString("movie-type.upcoming.title").resolve()
    static let movieTypeNowPlaying = LocalizedString("movie-type.now-playing.title").resolve()
    static let movieTypeTopRated = LocalizedString("movie-type.top-rated.title").resolve()
    
    //MARK: TMDB Error
    static let networkServiceError_invalidUrl = LocalizedString("network-service-error.invalid-url", comment: "The URL provided in not a valid HTTP URL.").resolve()
    static let networkServiceError_unknown = LocalizedString("network-service-error.unknown", comment: "Unknown network service error.").resolve()
    static let networkServiceError_unexpectedResponse = LocalizedString("network-service-error.unexpected-response", comment: "The network service returned an unexpected response.").resolve()
    static let networkServiceError_parseError = LocalizedString("network-service-error.parse-error", comment: "The network service returned a response that couldn't be parsed.").resolve()
}
