//
//  DetailView.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 09/01/24.
//

import UIKit
import Cosmos

protocol DetailViewDelegate: AnyObject {
    func didCastItemSelected(person: Person)
}

class DetailView: UIView {
    // MARK: -Variables
    var startLoading: (() -> Void)?
    var stopLoading: (() -> Void)?
    private var bannerHeightConstraint: NSLayoutConstraint?
    private var casts: [Cast] = []
    private var seasons: [Season] = []
    weak var delegate: DetailViewDelegate?
    
    // MARK: -UI Components
    private let bannerImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "EmptyShowBanner")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBg
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = "Show title"
        label.numberOfLines = 2
        label.textColor = UIColor.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genreStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let cosmosRatingView: CosmosView = {
        let view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.totalStars = 10
        view.settings.filledColor = .primary
        view.settings.emptyBorderColor = .primary
        view.settings.filledBorderColor = .primary
        view.settings.starSize = 17
        view.settings.starMargin = 3
        view.settings.fillMode = .precise
        view.text = "--/10"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let showInfoView: ShowInfoView = {
        let view = ShowInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let summaryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "Summary"
        label.textColor = UIColor.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "This is summary"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let castTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "Cast"
        label.textColor = UIColor.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let castColectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.identifier)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let episodesTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "Episodes"
        label.textColor = UIColor.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let episodeTableView: SelfSizedTableView = {
        let table = SelfSizedTableView(frame: .zero, style: .insetGrouped)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .none
        table.isScrollEnabled = false
        table.register(EpisodeTableViewCell.self, forCellReuseIdentifier: EpisodeTableViewCell.identifier)
        table.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: -Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        castColectionView.dataSource = self
        castColectionView.delegate = self
        episodeTableView.dataSource = self
        episodeTableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        bannerHeightConstraint?.constant = frame.size.width * 1.405
        layoutIfNeeded()
    }
    
    // MARK: -UI Setup
    private func setupView() {
        backgroundColor = UIColor.mainBg
        
        [bannerImageView, backgroundView, titleLabel, cosmosRatingView, genreStackView, showInfoView, summaryTitleLabel, summaryLabel, castTitleLabel, castColectionView, episodesTitleLabel, episodeTableView].forEach { addSubview($0)}
        
        bannerHeightConstraint = bannerImageView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerHeightConstraint!,
            
            backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.4),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            cosmosRatingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            cosmosRatingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            genreStackView.topAnchor.constraint(equalTo: cosmosRatingView.bottomAnchor, constant: 11),
            genreStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            showInfoView.topAnchor.constraint(equalTo: genreStackView.bottomAnchor, constant: 20),
            showInfoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            showInfoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            summaryTitleLabel.topAnchor.constraint(equalTo: showInfoView.bottomAnchor, constant: 24),
            summaryTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            summaryLabel.topAnchor.constraint(equalTo: summaryTitleLabel.bottomAnchor, constant: 6),
            summaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            summaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            castTitleLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 6),
            castTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            castColectionView.topAnchor.constraint(equalTo: castTitleLabel.bottomAnchor, constant: 10),
            castColectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            castColectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            castColectionView.heightAnchor.constraint(equalToConstant: 108),
            
            episodesTitleLabel.topAnchor.constraint(equalTo: castColectionView.bottomAnchor, constant: 24),
            episodesTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            episodeTableView.topAnchor.constraint(equalTo: episodesTitleLabel.bottomAnchor, constant: -16),
            episodeTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            episodeTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            episodeTableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
        ])
    }
    
    func configureShowData(with show: Show) {
        startLoading?()
        if let imageUrl = show.image?.original {
            bannerImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "EmptyShowBanner")) { _,_,_,_ in
                self.stopLoading?()
            }
            
        } else {
            self.stopLoading?()
        }
        if let rating = show.rating.average {
            cosmosRatingView.rating = rating
            cosmosRatingView.text = "\(rating)/10"
        } else {
            cosmosRatingView.rating = 0
        }
        titleLabel.text = show.name
        summaryLabel.attributedText = show.summary?.htmlToAttributedString()
        showInfoView.configure(language: show.language ?? "-", status: show.status, type: show.type)
        show.genres.forEach {
            let genreView = ChipTextView()
            genreView.setTitle($0)
            genreStackView.addArrangedSubview(genreView)
        }
    }
    
    func configureCastData(with casts: [Cast]) {
        self.casts = casts
        castColectionView.reloadData()
    }
    
    func configureEpisodeData(with seasons: [Season]) {
        self.seasons = seasons
        episodeTableView.reloadData()
    }
}

extension DetailView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return casts.isEmpty ? 1 : casts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier, for: indexPath) as? CastCollectionViewCell {
            if !casts.isEmpty {
                cell.configure(with: casts[indexPath.row])
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height-33, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !casts.isEmpty {
            self.delegate?.didCastItemSelected(person: casts[indexPath.item].person)
        }
    }
    
}

extension DetailView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return seasons.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Season \(seasons[section].season)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons[section].episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeTableViewCell.identifier, for: indexPath) as? EpisodeTableViewCell {
            let episode = seasons[indexPath.section].episodes[indexPath.row]
            cell.configure(with: episode)
            
            if indexPath.row == 0 {
                cell.setupFirstCell()
            }
            if tableView.numberOfRows(inSection: indexPath.section)-1 == indexPath.row {
                cell.setupLastCell()
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = 80
        
        if indexPath.row == 0 || tableView.numberOfRows(inSection: indexPath.section)-1 == indexPath.row {
            return cellHeight + 6
        } else {
            return cellHeight
        }
    }
}
