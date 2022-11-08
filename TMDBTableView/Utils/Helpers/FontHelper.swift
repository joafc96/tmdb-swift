//
//  FontHelper.swift
//  TMDBTableView
//
//  Created by qbuser on 19/10/22.
//

import UIKit

struct FontHelper {
    
    enum FontSize: CGFloat {
        case small = 14
        case medium = 15
        case large = 16
        case extraLarge = 18
    }
    
    static func bold(withSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
    }
    
    static func semiBold(withSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
    }
    
    static func regular(withSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
    }
    
    static func light(withSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
    }
    
}

extension FontHelper {
    struct Default {
        static let smallLight = FontHelper.light(withSize: FontSize.small.rawValue)
        static let smallRegular = FontHelper.regular(withSize: FontSize.small.rawValue)
        static let smallBold = FontHelper.bold(withSize: FontSize.small.rawValue)

        static let mediumLight = FontHelper.light(withSize: FontSize.medium.rawValue)
        static let mediumRegular = FontHelper.regular(withSize: FontSize.medium.rawValue)
        static let mediumBold = FontHelper.bold(withSize: FontSize.medium.rawValue)
        
        static let largeLight = FontHelper.light(withSize: FontSize.large.rawValue)
        static let largeRegular = FontHelper.regular(withSize: FontSize.large.rawValue)
        static let largeBold = FontHelper.bold(withSize: FontSize.large.rawValue)
        
        static let extraLargeLight = FontHelper.light(withSize: FontSize.extraLarge.rawValue)
        static let extraLargeBold = FontHelper.bold(withSize: FontSize.extraLarge.rawValue)
    }
    
}
