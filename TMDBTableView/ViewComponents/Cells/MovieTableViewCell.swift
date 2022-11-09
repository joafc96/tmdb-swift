//
//  MovieTableViewCell.swift
//  TMDBTableView
//
//  Created by qbuser on 04/10/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {    
    
    //MARK: - UI Properties
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .label
        lbl.font = FontHelper.Default.extraLargeBold
        lbl.textAlignment = .left
        //lbl.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        return lbl
    }()
    
    private let overViewLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .label
        lbl.font = FontHelper.Default.mediumRegular
        lbl.textAlignment = .left
        lbl.numberOfLines = 3
        //lbl.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return lbl
    }()
    
    private let posterImage: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 8
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .bottom
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 8
        
        return stackView
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Configurations
    private func configureUI() {
        // only need to add the outer stack view to the table view cell super view
        addSubview(mainStackView)
        
        // adding name and overview subviews to details stack view
        detailsStackView.addArrangedSubview(titleLabel)
        detailsStackView.addArrangedSubview(overViewLabel)
        
        // adding image and details subviews to image & details stack view
        mainStackView.addArrangedSubview(posterImage)
        mainStackView.addArrangedSubview(detailsStackView)
    }
    
    private func configureConstraints() {
        
        mainStackView.centerYInSuperview()
        mainStackView.constraintHeight(constant: 140)
        
        let mainStackViewConstraints = [
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ]
        
        let detailsStackViewConstraints = [
            detailsStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            detailsStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
        ]
        
        posterImage.constraintWidth(constant: 100)
        posterImage.constraintHeight(constant: 140)
        
        NSLayoutConstraint.activate(detailsStackViewConstraints)
        NSLayoutConstraint.activate(mainStackViewConstraints)
    }

    public func configureCell(with movie: Movie) {
        titleLabel.text = movie.title
        overViewLabel.text = movie.overview
        guard let posterPath = movie.posterPath else { return }
        guard let imageUrl = Endpoint.posterImage(path: posterPath, quality: ImageQuality.posterMedium.rawValue).imageUrl else { return }
//        posterImage.alpha = 0.0
        posterImage.set(for: imageUrl)
//        posterImage.fadeIn(with: 0.5)
    }
}
