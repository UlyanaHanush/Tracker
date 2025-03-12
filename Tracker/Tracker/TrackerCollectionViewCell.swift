//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by ulyana on 12.03.25.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    static let cellIdentifier = "TrackerCollectionViewCell"
    
    // MARK: - Private Properties
    
    lazy var cardView: UIView = {
        let card = UIView()
        
        card.backgroundColor = .red
        
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 16
        return card
    }()
    
    lazy var nameLabel: UILabel = {
        let name = UILabel()
        
        name.text = "Сделать сюрприз маме"
        
        name.textColor = .white
        name.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        name.numberOfLines = 0
        
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var emojiLabel: UILabel = {
        let emoji = UILabel()
        
        emoji.text = "🌺"
        
        emoji.clipsToBounds = true
        emoji.layer.cornerRadius = 16
        emoji.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        emoji.font = .systemFont(ofSize: 16)
        emoji.textAlignment = .center
        
        emoji.translatesAutoresizingMaskIntoConstraints = false
        return emoji
    }()
    
    lazy var daysLabel: UILabel = {
        let days = UILabel()
        
        days.text = "4 дня"
        
        days.translatesAutoresizingMaskIntoConstraints = false
        days.font = .systemFont(ofSize: 12, weight: .medium)
        return days
    }()
    
    lazy var plusButton: UIButton = {
        
        let plus = UIButton()
        let image = UIImage(systemName: "plus")

        plus.setImage(image, for: .normal)
        
        plus.backgroundColor = .red
        
        plus.tintColor = .white
        plus.layer.cornerRadius = 20
        plus.addTarget(nil, action: #selector(checkForToday), for: .touchUpInside)
        
        plus.translatesAutoresizingMaskIntoConstraints = false
        return plus
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        print("\(#file):\(#line)] \(#function) Ошибка: init(coder:) не реализован")
        return nil
    }
    
    // MARK: - IBAction
    
    @IBAction private func checkForToday() {
        
    }
    
    // MARK: - Private Methods
    
    private func constraintSubviews() {
           NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
               
            nameLabel.topAnchor.constraint(greaterThanOrEqualTo: emojiLabel.bottomAnchor, constant: 4),
            nameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
               
            emojiLabel.heightAnchor.constraint(equalToConstant: 30),
            emojiLabel.widthAnchor.constraint(equalToConstant: 30),
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
               
            daysLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
               
            plusButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            //daysLabel.trailingAnchor.constraint(greaterThanOrEqualTo: plusButton.leadingAnchor, constant: 4),
            //plusButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.widthAnchor.constraint(equalToConstant: 34)
           ])
       }
    
    private func addSubviews() {
        contentView.addSubview(cardView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(emojiLabel)
        contentView.addSubview(daysLabel)
        contentView.addSubview(plusButton)
        
        constraintSubviews()
    }
}
