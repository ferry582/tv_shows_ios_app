//
//  CastCollectionViewCell.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 09/01/24.
//

import UIKit
import SDWebImage

class CastCollectionViewCell: UICollectionViewCell {
    
    // MARK: -Variables
    static let identifier = "CastCollectionViewCell"
    
    // MARK: -UI Components
    private let castImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "EmptyShowBanner")
        iv.contentMode = .scaleAspectFill
        iv.sd_imageIndicator = SDWebImageActivityIndicator.gray
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "Name"
        label.textColor = UIColor.primaryText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let characterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "Character"
        label.textColor = UIColor.secondaryText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: -Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        castImageView.layer.cornerRadius = self.frame.size.width/2
    }
    
    // MARK: -UI Setup
    private func setupView() {
        contentView.addSubview(castImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(characterLabel)
        
        NSLayoutConstraint.activate([
            castImageView.topAnchor.constraint(equalTo: topAnchor),
            castImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            castImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            castImageView.heightAnchor.constraint(equalTo: castImageView.widthAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            characterLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            characterLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            characterLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            characterLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configure(with cast: Cast) {
        if let imageUrl = cast.person.image?.medium {
            castImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "EmptyShowBanner"))
        } else {
            castImageView.sd_imageIndicator = .none
        }
        nameLabel.text = cast.person.name
        characterLabel.text = cast.character.name
    }
}
