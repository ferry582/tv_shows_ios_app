//
//  ShowInfoView.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 08/01/24.
//

import UIKit

class ShowInfoView: UIView {
    // MARK: UI Components
    private let languageTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "Language"
        label.textColor = UIColor.secondaryText
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "English"
        label.textColor = UIColor.primaryText
        return label
    }()
    
    private lazy var languageStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 3
        sv.alignment = .leading
        sv.addArrangedSubview(languageTitleLabel)
        sv.addArrangedSubview(languageLabel)
        return sv
    }()
    
    private let statusTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "Status"
        label.textColor = UIColor.secondaryText
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "Ended"
        label.textColor = UIColor.primaryText
        return label
    }()
    
    private lazy var statusStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 3
        sv.alignment = .leading
        sv.addArrangedSubview(statusTitleLabel)
        sv.addArrangedSubview(statusLabel)
        return sv
    }()

    private let typeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "Type"
        label.textColor = UIColor.secondaryText
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "Scripted"
        label.textColor = UIColor.primaryText
        return label
    }()
    
    private lazy var typeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 3
        sv.alignment = .leading
        sv.addArrangedSubview(typeTitleLabel)
        sv.addArrangedSubview(typeLabel)
        return sv
    }()
    
    private let showInfoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 32
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: UI Setup
    private func setupView() {
        showInfoStackView.addArrangedSubview(languageStackView)
        showInfoStackView.addArrangedSubview(statusStackView)
        showInfoStackView.addArrangedSubview(typeStackView)
        
        addSubview(showInfoStackView)
        
        NSLayoutConstraint.activate([
            showInfoStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            showInfoStackView.topAnchor.constraint(equalTo: topAnchor),
            showInfoStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(language: String, status: String, type: String) {
        languageLabel.text = language
        statusLabel.text = status
        typeLabel.text = type
    }
}
