//
//  TMDBError.swift
//  TMDBTableView
//
//  Created by qbuser on 04/10/22.
//

import Foundation

enum TMDBError: Error {
    case invalidUrl
    case unknownError
    case unexpectedResponse
    case parseError

    var localized: String {
        switch self {
        case .invalidUrl:
            return L10n.networkServiceError_invalidUrl
        case .unknownError:
            return L10n.networkServiceError_unknown
        case .unexpectedResponse:
            return L10n.networkServiceError_unexpectedResponse
        case .parseError:
            return L10n.networkServiceError_parseError
        }
    }
}
