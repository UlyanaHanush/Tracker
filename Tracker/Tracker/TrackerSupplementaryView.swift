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
    
    
    let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(title)
        title.font = .systemFont(ofSize: 18, weight: .bold)
        title.textColor = .black
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            title.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: 12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

