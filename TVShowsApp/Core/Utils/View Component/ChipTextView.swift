//
//  ChipText.swift
//  TVShowsApp
//
//  Created by Ferry Dwianta P on 07/01/24.
//

import UIKit

class ChipTextView: UIView {
    
    // MARK: UI Components
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "Title"
        label.textColor = UIColor.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .primary.withAlphaComponent(0.2)
        layer.cornerRadius = 6
        clipsToBounds = true
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: UI Setup
    private func setupView() {
        addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3)
        ])
    }
    
    func setTitle(_ title: String) {
        textLabel.text = title
    }
    
    func useWhiteBackround() {
        backgroundColor = UIColor(white: 1, alpha: 0.7)
    }
}
