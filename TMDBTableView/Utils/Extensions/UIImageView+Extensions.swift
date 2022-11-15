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
    
    /**
     Scale down animation to with duration and scale value.
     - parameter scaleValue: scale down scale value for x and y
     - parameter duration: custom animation duration
     */
    func scaleDownAnimate(to scaleValue: CGFloat,  with duration: CGFloat = 0.2) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: scaleValue, y: scaleValue)
        }, completion: { finished in
            UIView.animate(withDuration: duration, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
}
