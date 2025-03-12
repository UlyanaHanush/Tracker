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
    
    private lazy var trackerName: UITextField = {
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
        
        contentView.addSubview(trackerName)
        
        setupConstraints()
        contentView.backgroundColor = .bgTableView
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

//class TextFieldCell: UITableViewCell {
//    
//    static let reuseIdentifier = "TextFieldCell"
//    
//    var delegate: TextFieldCellDelegate?
//    
//    var placeholder: String? {
//        get { textField.placeholder }
//        set { textField.placeholder = newValue }
//    }
//    
//    private lazy var textField: UITextField = {
//        let textField = UITextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.clearButtonMode = .always
//        textField.delegate = self
//        return textField
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupSubviews()
//    }
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupSubviews() {
//        addSubviews()
//        constraintSubviews()
//        backgroundColor = .bgTableView
//        selectionStyle = .none
//    }
//    
//    private func addSubviews() {
//        contentView.addSubview(textField)
//    }
//    
//    private func constraintSubviews() {
//        NSLayoutConstraint.activate([
//            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
//            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            textField.heightAnchor.constraint(equalToConstant: 30)
//        ])
//    }
//}

