//
//  HabitCreatingPresenter.swift
//  Tracker
//
//  Created by ulyana on 8.03.25.
//

import Foundation
import UIKit

protocol HabitPresenterProtocol {
    var view: HabitViewControllerProtocol? { get }
    var trackerType: TrackerType { get set }
    var trackerName: String? { get set }
    var selectedCategory: TrackerCategory? { get }
    var schedule: [WeekDay] { get set }
    var emojiCollectionView: [SectionHabitCollectionView] { get set }
    var colorCollectionView: [SectionHabitCollectionView] { get set }
    var selectedEmoji: String? { get set }
    var selectedColor: UIColor? { get set }
    func isValidForm() -> Bool
    func createNewTracker()
    func getShortFormWeekDays() -> String
}

final class HabitPresenter: HabitPresenterProtocol {
    
    // MARK: - Constants
    
    let formatter = Formatter()
    var emojiCollectionView: [SectionHabitCollectionView] = [
        SectionHabitCollectionView(title: "Emoji", row: ["😊", "🐱", "🎯", "🐶", "❤️", "😱","😇", "😡", "🥶", "🤔", "🌟", "🍔", "🥦", "🏓", "🥇", "🎸", "🌴", "😭"])]
    var colorCollectionView: [SectionHabitCollectionView] = [
        SectionHabitCollectionView(title: "Цвет", row: [
            UIColor.systemRed,
            UIColor.systemOrange,
            UIColor.systemBlue,
            UIColor.systemPurple,
            UIColor.systemGreen,
            UIColor.systemPink,
            UIColor.systemRed.withAlphaComponent(0.3),
            UIColor.systemBlue.withAlphaComponent(0.3),
            UIColor.systemGreen.withAlphaComponent(0.3),
            UIColor.systemPurple.withAlphaComponent(0.3),
            UIColor.systemOrange.withAlphaComponent(0.3),
            UIColor.systemPink.withAlphaComponent(0.3),
            UIColor.systemOrange.withAlphaComponent(0.6),
            UIColor.systemBlue.withAlphaComponent(0.6),
            UIColor.systemPurple.withAlphaComponent(0.6),
            UIColor.systemPurple.withAlphaComponent(0.7),
            UIColor.systemPurple.withAlphaComponent(0.8),
            UIColor.systemGreen.withAlphaComponent(0.6)
        ])
    ]
     
    // MARK: - Publike Properties
    
    weak var view: HabitViewControllerProtocol?
    var trackerType: TrackerType
    var delegate: HabitCreatingDelegate?
    var schedule: [WeekDay] = []
    var trackerName: String?
    var selectedCategory: TrackerCategory?
    var categories: [TrackerCategory]
    var selectedEmoji: String?
    var selectedColor: UIColor?


    // MARK: - Initializers
    
    init(trackerType: TrackerType, categories: [TrackerCategory]) {
        self.trackerType = trackerType
        self.categories = categories
        self.selectedCategory = categories.first
    }
    
    // MARK: - Publike Methods
    
    func isValidForm() -> Bool {
        if let trackerName {
            switch trackerType {
            case .Habit:
                return selectedCategory != nil && !trackerName.isEmpty && !schedule.isEmpty
            case .UnRegularEvent:
                return selectedCategory != nil && !trackerName.isEmpty
            }
        } else {
            return false
        }
    }
    
    func createNewTracker() {
        guard let name = trackerName, let selectedCategory else { return }
        
        //let data = formatter.dateFormatter.string(from: Date())
        let newTracker = Tracker(id: UUID(), name: name, color: selectedColor ?? .clear, emoji: selectedEmoji ?? "", schedule: schedule, creationDate: Date())
    
        delegate?.didCreateTracker(newTracker, at: selectedCategory)
    }
    
    func getShortFormWeekDays() -> String {
        let sortedWeekDays = schedule.sorted { day1, day2 in
            day1.rawValue < day2.rawValue
        }
        let weekDaysShortForm = sortedWeekDays.map { $0.shortForm }.joined(separator: ", ")
        
        let isAllDay: Bool = sortedWeekDays.count == 7 ? true : false
        let weekDaysForm = isAllDay ? "Каждый день": weekDaysShortForm
        return weekDaysForm
    }
}
