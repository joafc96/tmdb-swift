//
//  LocalizedString.swift
//  TMDBTableView
//
//  Created by qbuser on 12/10/22.
//

import Foundation

struct LocalizedString {
    let key: String
    let comment: String

    init(_ key: String, comment: String = "") {
        self.key = key
        self.comment = comment
    }

    func resolve(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        NSLocalizedString(key, tableName: tableName, comment: comment)
    }
}
