//
//  HabitCollectionViewCell.swift
//  Tracker
//
//  Created by ulyana on 21.03.25.
//

import UIKit

final class HabitCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    static let cellIdentifier = "HabitCollectionViewCell"
    
    // MARK: - Constants
    
    var titleLabel: UILabel = UILabel()
    let viewCell = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(viewCell)
        viewCell.addSubview(titleLabel)
        
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        viewCell.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewCell.widthAnchor.constraint(equalTo: viewCell.heightAnchor),
            viewCell.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            viewCell.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            viewCell.widthAnchor.constraint(equalToConstant: 36),
            
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
