//
//  TrackerSupplementaryView.swift
//  Tracker
//
//  Created by ulyana on 12.03.25.
//

import UIKit

class TrackerSupplementaryView: UICollectionReusableView {
    
    // MARK: - Constants
    
    static let supplementaryIdentifier = "header"

    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 18, weight: .bold)
        title.textColor = .black
        
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func addSubview() {
        addSubview(titleLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: 12)
        ])
    }
}

