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
    
    // MARK: - Publike Properties
    
    var delegate: TrackerCollectionViewCellDelegate?
    var completedDaysCount: Int = 0
    var isCompleted: Bool = false
    var currentDate: Date?
    var tracker: Tracker?
    
    lazy var cardView: UIView = {
        let card = UIView()
        card.backgroundColor = .red
        card.layer.cornerRadius = 16
        
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    lazy var nameLabel: UILabel = {
        let name = UILabel()
        name.textColor = .white
        name.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        name.numberOfLines = 0
        
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var emojiLabel: UILabel = {
        let emoji = UILabel()
        emoji.clipsToBounds = true
        emoji.layer.cornerRadius = 16
        emoji.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        emoji.font = .systemFont(ofSize: 16)
        emoji.textAlignment = .center
        emoji.text = "🌺"
        
        emoji.translatesAutoresizingMaskIntoConstraints = false
        return emoji
    }()
    
    lazy var counterLabel: UILabel = {
        let days = UILabel()
        days.font = .systemFont(ofSize: 12, weight: .medium)
        
        days.translatesAutoresizingMaskIntoConstraints = false
        return days
    }()
    
    lazy var plusCompletedButton: UIButton = {
        let plus = UIButton()
        plus.backgroundColor = .red
        plus.tintColor = .white
        plus.layer.cornerRadius = 17
        
        let image = UIImage(systemName: "plus")
        plus.setImage(image, for: .normal)
        
        plus.addTarget(nil, action: #selector(plusCompleteButtonTapped), for: .touchUpInside)
        
        plus.translatesAutoresizingMaskIntoConstraints = false
        return plus
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        print("\(#file):\(#line)] \(#function) Ошибка: init(coder:) не реализован")
        return nil
    }
    
    // MARK: - Publike Methods
    
    func configure(with tracker: Tracker, currentDate: Date, completedDaysCount: Int, isCompleted: Bool) {
        self.tracker = tracker
        self.currentDate = currentDate
        self.completedDaysCount = completedDaysCount
        self.isCompleted = isCompleted
        
        nameLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        cardView.backgroundColor = tracker.color
        counterLabel.text = "\(completedDaysCount) дней"
        setCompletedStateForButton(isCompleted)
    }
    
    // MARK: - IBAction
    
    @IBAction private func plusCompleteButtonTapped() {
        guard let tracker = self.tracker,
              let currentDate = self.currentDate else { return }
        
        if isFutureDate(currentDate) {
            print("\(#file):\(#line)] \(#function) Нельзя отметить трекер на будущую дату")
            return
        }
        
        isCompleted.toggle()
        completedDaysCount += isCompleted ? 1 : -1
        counterLabel.text = "\(completedDaysCount) дней"
        setCompletedStateForButton(isCompleted)

        delegate?.didComplete(tracker, date: currentDate)
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
            
            counterLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            plusCompletedButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            plusCompletedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            plusCompletedButton.heightAnchor.constraint(equalToConstant: 34),
            plusCompletedButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func addSubviews() {
        contentView.addSubview(cardView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(emojiLabel)
        
        contentView.addSubview(counterLabel)
        contentView.addSubview(plusCompletedButton)
        
        constraintSubviews()
    }
    
    private func isFutureDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selectedDate = calendar.startOfDay(for: date)
        return selectedDate > today
    }
    
    private func setCompletedStateForButton(_ isCompleted: Bool) {
        let doneImage = isCompleted ? UIImage(named: "done") : UIImage(systemName: "plus")
        plusCompletedButton.setImage(doneImage, for: .normal)
        plusCompletedButton.alpha = isCompleted ? 0.3 : 1.0
    }
}
