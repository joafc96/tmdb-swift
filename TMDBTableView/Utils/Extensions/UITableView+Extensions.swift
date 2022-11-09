//
//  UITableView+Extensions.swift
//  TMDBTableView
//
//  Created by qbuser on 08/11/22.
//

import UIKit

extension UITableView {
    func dequeueReusableCellForIndexPath<T: UITableViewCell>(_ indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.nameOfClass, for: indexPath) as! T
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.nameOfClass) as! T
    }
}
