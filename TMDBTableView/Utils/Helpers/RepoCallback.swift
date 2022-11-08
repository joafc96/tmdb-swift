//
//  RepoCallback.swift
//  TMDBTableView
//
//  Created by qbuser on 08/11/22.
//

import Foundation

public typealias RepoCallback<T> = (Result<T, Error>) -> Void
