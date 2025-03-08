//
//  TextFieldCell.swift
//  Tracker
//
//  Created by ulyana on 7.03.25.
//

import UIKit

final class TextFieldCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let reuseIdentifier = "TextFieldCell"
    
    // MARK: - Private Properties
    
    private lazy var trackerName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        contentView.addSubview(trackerName)
        
        setupConstraints()
        contentView.backgroundColor = .bgTabelView
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            trackerName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trackerName.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
