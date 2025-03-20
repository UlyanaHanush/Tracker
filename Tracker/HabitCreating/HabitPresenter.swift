//
//  HabitCreatingPresenter.swift
//  Tracker
//
//  Created by ulyana on 8.03.25.
//

import Foundation

protocol HabitPresenterProtocol {
    var view: HabitViewControllerProtocol? { get }
    var trackerType: TrackerType { get set }
    var trackerName: String? { get set }
    var selectedCategory: TrackerCategory? { get }
    var schedule: [WeekDay] { get set }
    func isValidForm() -> Bool
    func createNewTracker()
    func getShortFormWeekDays() -> String
}

final class HabitPresenter: HabitPresenterProtocol {
    
    // MARK: - Constants
    
    let formatter = Formatter()
    
    // MARK: - Publike Properties
    
    weak var view: HabitViewControllerProtocol?
    var trackerType: TrackerType
    var delegate: HabitCreatingDelegate?
    var schedule: [WeekDay] = []
    var trackerName: String?
    var selectedCategory: TrackerCategory?
    var categories: [TrackerCategory]

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
        
        let data = formatter.dateFormatter.string(from: Date())
        let newTracker = Tracker(id: UUID(), name: name, color: .red, emoji: "🌺", schedule: schedule, creationDate: data)
    
        delegate?.didCreateTracker(newTracker, at: selectedCategory)
    }
    
    func getShortFormWeekDays() -> String {
        let sortedWeekDays = schedule.sorted { day1, day2 in
            day1.rawValue < day2.rawValue
        }
        let weekDaysShortForm = sortedWeekDays.map { $0.shortForm }.joined(separator: ", ")
        
        var isAllDay: Bool = sortedWeekDays.count == 7 ? true : false
        let weekDaysForm = isAllDay ? "Каждый день": weekDaysShortForm
        return weekDaysForm
    }
}
