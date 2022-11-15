//
//  MovieDetailsView.swift
//  TMDBTableView
//
//  Created by qbuser on 10/11/22.
//

import UIKit

class MovieDetailsView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .systemBackground
        configureSubViews()
        configureConstraints()
    }
    
    private func configureSubViews() {
        
    }
    
    private func configureConstraints() {
        
    }

}
