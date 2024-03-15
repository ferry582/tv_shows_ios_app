//
//  ShowCollectionViewCell.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 06/01/24.
//

import UIKit
import SDWebImage

class ShowCollectionViewCell: UICollectionViewCell {
    // MARK: -Variables
    static let identifier = "ShowCollectionViewCell"
    
    // MARK: -UI Components
    private let bannerImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "EmptyShowBanner")
        iv.contentMode = .scaleAspectFit
        iv.sd_imageIndicator = SDWebImageActivityIndicator.gray
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "Show title"
        label.textColor = UIColor.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "star.fill")
        iv.tintColor = .yellowRating
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "--/10"
        label.textColor = UIColor.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let languageTextView: ChipTextView = {
        let view = ChipTextView()
        view.setTitle("-")
        view.useWhiteBackround()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: -Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -UI Setup
    
    private func setupView() {
        contentView.addSubview(bannerImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingIconImageView)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(languageTextView)
        
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            bannerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            
            ratingIconImageView.heightAnchor.constraint(equalToConstant: 10),
            ratingIconImageView.widthAnchor.constraint(equalToConstant: 10),
            ratingIconImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            ratingIconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ratingIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            
            ratingLabel.centerYAnchor.constraint(equalTo: ratingIconImageView.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingIconImageView.trailingAnchor, constant: 3),
            
            languageTextView.bottomAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: -7),
            languageTextView.trailingAnchor.constraint(equalTo: bannerImageView.trailingAnchor, constant: -7)
        ])
    }
    
    func configure(with show: Show) {
        if let imageUrl = show.image?.medium {
            bannerImageView.sd_setImage(with: URL(string: imageUrl))
        } else {
            bannerImageView.sd_imageIndicator = .none
        }
        if let rating = show.rating.average {
            ratingLabel.text = "\(rating)/10"
        }
        if let language = show.language {
            languageTextView.setTitle(language)
        }
        titleLabel.text = show.name
    }
}
