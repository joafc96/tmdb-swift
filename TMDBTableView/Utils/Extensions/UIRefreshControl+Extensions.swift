//
//  UIRefreshControl+Extensions.swift
//  TMDBTableView
//
//  Created by qbuser on 19/10/22.
//

import UIKit

extension UIRefreshControl {
    func endRefreshing(with delay: TimeInterval = 0.5) {
        if isRefreshing {
            perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: delay)
        }
        
    }
}
