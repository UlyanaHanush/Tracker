//
//  TableViewCell.swift
//  Tracker
//
//  Created by ulyana on 7.03.25.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    // MARK: - Constants

    static let reuseIdentifier = "CategoriesAndScheduleCell"
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupSubviews() {
        backgroundColor = .bgTableView
        textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        textLabel?.textColor = .black
//        detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
//        detailTextLabel?.textColor = .tGray
        selectionStyle = .default
    }
}
