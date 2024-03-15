//
//  EpisodeTableViewCell.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 09/01/24.
//

import UIKit
import SDWebImage

class EpisodeTableViewCell: UITableViewCell {
    // MARK: - Variables
    static let identifier = "EpisodeTableViewCell"
    private var imageTopConstraint: NSLayoutConstraint?
    private var imageBottomConstraint: NSLayoutConstraint?
    
    // MARK: - UI Components
    private let episodeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "EmptyShowBanner")
        iv.contentMode = .scaleAspectFill
        iv.sd_imageIndicator = SDWebImageActivityIndicator.gray
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = "1"
        label.textColor = UIColor.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = "Episode title"
        label.textColor = UIColor.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "2024-02-01"
        label.textColor = UIColor.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Set Up
    private func setupView() {
        contentView.addSubview(episodeImageView)
        contentView.addSubview(numberLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        
        imageTopConstraint = episodeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6)
        imageBottomConstraint = episodeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        
        NSLayoutConstraint.activate([
            episodeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageTopConstraint!,
            imageBottomConstraint!,
            episodeImageView.widthAnchor.constraint(equalTo: episodeImageView.heightAnchor, constant: 25),
            
            numberLabel.topAnchor.constraint(equalTo: episodeImageView.topAnchor, constant: 6),
            numberLabel.leadingAnchor.constraint(equalTo: episodeImageView.trailingAnchor, constant: 10),
            
            titleLabel.leadingAnchor.constraint(equalTo: episodeImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 0),
            
            dateLabel.leadingAnchor.constraint(equalTo: episodeImageView.trailingAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: episodeImageView.bottomAnchor, constant: -7),
        ])
        
    }
    
    func configure(with episode: Episode) {
        if let imageUrl = episode.image?.medium {
            episodeImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "EmptyShowBanner"))
        } else {
            episodeImageView.sd_imageIndicator = .none
        }
        numberLabel.text = "S\(episode.season) E\(episode.number)"
        titleLabel.text = episode.name
        dateLabel.text = episode.airdate
    }
    
    func setupLastCell() {
        imageBottomConstraint?.constant = -12
        layoutIfNeeded()
    }
    
    func setupFirstCell() {
        imageTopConstraint?.constant = 12
        layoutIfNeeded()
    }
    
}
