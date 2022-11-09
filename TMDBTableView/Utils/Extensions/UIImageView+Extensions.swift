//
//  UIImageView+Extensions.swift
//  TMDBTableView
//
//  Created by qbuser on 08/11/22.
//

import Foundation
import SDWebImage

extension UIImageView {
    func set(for imageUrl: URL, initialContentMode: UIView.ContentMode = .center) {
        let placeholderImage = UIImage(systemName: "photo")
        contentMode = initialContentMode
        image = placeholderImage
        sd_setImage(with: imageUrl, placeholderImage: placeholderImage) { [weak self] (image, error, cacheType, imageUrl) in
            if error == nil {
                self?.contentMode = .scaleAspectFit
            }
        }
    }
}
