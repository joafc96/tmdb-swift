//
//  ViewState.swift
//  TMDBTableView
//
//  Created by qbuser on 08/10/22.
//

import Foundation

enum PaginationViewState<Entity>: Equatable where Entity: Equatable {
    case uninitialized
    case initialFetching
    case refreshing
    case moreFetching(currentEntities: [Entity], next: Int)
    case fetched([Entity], current: Int)
    case empty
    case error(Error)
    
    static func == (lhs: PaginationViewState, rhs: PaginationViewState) -> Bool {
        switch (lhs, rhs) {
        case (.uninitialized, .uninitialized):
            return true
        case (.refreshing, .refreshing):
            return true
        case (.initialFetching, .initialFetching):
            return true
        case (let .moreFetching(lhsEntities, _), let .moreFetching(rhsEntities, _)):
            return lhsEntities == rhsEntities
        case (let .fetched(lhsEntities, _), let .fetched(rhsEntities, _)):
            return lhsEntities == rhsEntities
        case (.empty, .empty):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
    
    var currentEntities: [Entity] {
        switch self {
        case .fetched(let entities, _), .moreFetching(let entities, _):
            return entities
        case .uninitialized, .refreshing, .initialFetching, .empty, .error:
            return []
        }
    }
    
    var currentState: PaginationViewState {
        switch self {
        case .uninitialized:
            return .uninitialized
        case .refreshing:
            return.refreshing
        case .initialFetching:
            return .initialFetching
        case .moreFetching(let entities, next: let page):
            return .moreFetching(currentEntities: entities, next: page)
        case .fetched(let entities, current: let page):
            return .fetched(entities, current: page)
        case .empty:
            return .empty
        case .error(let error):
            return .error(error)
        }
    }
    
    var currentPage: Int {
        switch self {
        case .uninitialized, .refreshing, .initialFetching, .empty, .error:
            return 1
        case .moreFetching(_, let page):
            return page
        case .fetched(_, let page):
            return page
        }
    }
    
    var isInitialPage: Bool {
        return currentPage == 1
    }
    
    
    var needsPrefetch: Bool {
        switch self {
        case .uninitialized, .refreshing, .initialFetching, .fetched, .empty, .error:
            return false
        case .moreFetching:
            return true
        }
    }
}
