//
//  InfiniteScrollActivityView.swift
//  TMDBTableView
//
//  Created by qbuser on 06/10/22.
//

import UIKit

class InfiniteScrollActivityView: UIView {
    
    static let defaultHeight: CGFloat = 60.0
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .medium)
        activityView.hidesWhenStopped = true
        
        return activityView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureActivityIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /* The center of the activity view is set in layoutSubviews because each time the frame of the view is changed layoutSubview method also will be called. view setFrame intelligently calls layoutSubviews on the view having its frame set only if the size parameter of the frame is different
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPoint(x: self.bounds.size.width / 2,
                                               y: self.bounds.size.height / 2)
    }
    
    private func configureActivityIndicator() {
        self.addSubview(activityIndicatorView)
    }
    
    
    //MARK: - Public methods
    public func startAnimating() {
        self.isHidden = false
        self.activityIndicatorView.startAnimating()
    }
    
    public func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.isHidden = true
    }
    
    public func isAnimating() -> Bool {
        let isAnimating = self.activityIndicatorView.isAnimating
        return isAnimating
    }
}
