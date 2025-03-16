//
//  TextFieldCell.swift
//  Tracker
//
//  Created by ulyana on 7.03.25.
//

import UIKit

protocol TextFieldCellDelegate {
    func didTextChange(text: String?)
}

final class TextFieldCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let reuseIdentifier = "TextFieldCell"
    
    // MARK: - Publike Properties
    
    var delegate: TextFieldCellDelegate?
    
    // MARK: - Private Properties
    
    private lazy var trackerNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.clearButtonMode = .always
        textField.delegate = self
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        addSubviews()
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            trackerNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trackerNameTextField.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func addSubviews() {
        contentView.addSubview(trackerNameTextField)
        setupConstraints()
        contentView.backgroundColor = .bgTableView
    }
}

// MARK: - UITextFieldDelegate

extension TextFieldCell: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didTextChange(text: textField.text)
    }
}
