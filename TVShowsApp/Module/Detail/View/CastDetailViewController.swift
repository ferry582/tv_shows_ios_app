//
//  CastViewController.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 09/01/24.
//

import UIKit
import SDWebImage

class CastDetailViewController: UIViewController {
    // MARK: -Variables
    private let person: Person
    
    // MARK: -UI Components
    private let pullIndicatorView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        view.heightAnchor.constraint(equalToConstant: 5).isActive = true
        return view
    }()
    
    private let castImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "EmptyShowBanner")
        iv.contentMode = .scaleAspectFill
        iv.sd_imageIndicator = SDWebImageActivityIndicator.gray
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = "Empty name"
        label.numberOfLines = 2
        label.textColor = UIColor.primaryText
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Empty age"
        label.textColor = UIColor.secondaryText
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Empty country"
        label.textColor = UIColor.secondaryText
        return label
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 4
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: -Life Cycle
    init(person: Person) {
        self.person = person
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupPerson()
    }
    
    // MARK: -UI Setup
    private func setupView() {
        view.backgroundColor = UIColor.mainBg
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(ageLabel)
        stackView.addArrangedSubview(countryLabel)
        
        view.addSubview(pullIndicatorView)
        view.addSubview(castImageView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            pullIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pullIndicatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            
            castImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            castImageView.topAnchor.constraint(equalTo: pullIndicatorView.bottomAnchor, constant: 26),
            castImageView.widthAnchor.constraint(equalToConstant: 100),
            castImageView.heightAnchor.constraint(equalToConstant: 148),
            
            stackView.topAnchor.constraint(equalTo: castImageView.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: castImageView.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupPerson() {
        if let imageUrl = person.image?.original {
            castImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "EmptyShowBanner"))
        } else {
            castImageView.sd_imageIndicator = .none
        }
        nameLabel.text = person.name
        ageLabel.text = {
            if let birthday = person.birthday?.stringToDate() {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year], from: birthday, to: Date())
                return "\(components.year ?? 0) years old"
            } else {
                return "- years old"
            }
        }()
        countryLabel.text = person.country?.name
    }
}
