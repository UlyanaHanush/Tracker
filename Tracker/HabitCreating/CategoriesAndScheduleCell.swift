//
//  CategoriesAndScheduleCell.swift
//  Tracker
//
//  Created by ulyana on 7.03.25.
//

import UIKit

final class CategoriesAndScheduleCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let reuseIdentifier = "CategoriesAndScheduleCell"
    
    // MARK: - Private Properties
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        let imageButton = UIImage(named: "forwardButton")
        button.setImage(imageButton, for: .normal)
        button.tintColor = .black
        
        button.addTarget(nil, action: #selector(didHabitButton(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    // MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(forwardButton)
        
        setupConstraints()
        contentView.backgroundColor = .bgTabelView
    }
    
    // MARK: - IBAction
    
    @IBAction private func didHabitButton(_ sender: Any) {
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            
            forwardButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            forwardButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
}
