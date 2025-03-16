//
//  TrackerPresenter.swift
//  Tracker
//
//  Created by ulyana on 11.03.25.
//

import Foundation

protocol TrackersPresenterProtocol {
    var view: TrackersViewControllerProtocol? { get }
    var categories: [TrackerCategory] { get }
    var completedTrackers: Set<TrackerRecord> { get set }
    func addTracker(_ tracker: Tracker, at category: TrackerCategory)
    func filterTrackersByDate(_ date: Date)
}

final class TrackersPresenter: TrackersPresenterProtocol {
    
    // MARK: - Constants
    
    let formatter = Formatter()
    
    // MARK: - Publike Properties
    
    weak var view: TrackersViewControllerProtocol?
    var completedTrackers: Set<TrackerRecord> = []
    var categories: [TrackerCategory] = []
    var search: String = ""
    var currentDate: Date = Date()
    var filteredCategories: [TrackerCategory] = []
    
    // MARK: - Initializers
    
    init() {
        let tracker = Tracker(id: UUID(), name: "Помочь бабушке", color: .red, emoji: "❤️", schedule: [.monday], creationDate: "14.03.2025")
        let category = TrackerCategory(title: "Обязательства перед семьей", trackers: [tracker])
        categories.append(category)
        
        let tracker1 = Tracker(id: UUID(), name: "Сходить в бассейн", color: .green, emoji: "😻", schedule: [.friday, .tuesday], creationDate: "12.03.2025")
        let tracker2 = Tracker(id: UUID(), name: "Устроить бьюти день", color: .blue, emoji: "🌺", schedule: [.thursday, .saturday], creationDate: "11.03.2025")
        let tracker3 = Tracker(id: UUID(), name: "Занятия теннисом", color: .yellow, emoji: "❤️", schedule: [.sunday, .wednesday, .friday], creationDate: "13.03.2025")
        let category2 = TrackerCategory(title: "Красота", trackers: [tracker1, tracker2, tracker3])
        categories.append(category2)
    }
    
    // MARK: - Publike Methods
    
    func addTracker(_ tracker: Tracker, at category: TrackerCategory) {
        var trackers = category.trackers
        trackers.append(tracker)
        
        let newCategory = TrackerCategory(title: category.title, trackers: trackers)
        
        var categories = self.categories
        
        if let index = categories.firstIndex(where: { $0.title == category.title } ) {
            categories[index] = newCategory
        } else {
            categories.append(newCategory)
        }
        self.categories = categories
        
        filterTrackersByDate(currentDate)
        view?.didAddTracker()
    }
    
    func completeTracker(_ tracker: Tracker, date: Date) {
        if isTrackerCompleted(tracker, date: date) {
            removeFromCompletedTrackers(tracker: tracker, date: currentDate)
        } else {
            addToCompletedTrackers(tracker: tracker, date: currentDate)
        }
    }
    
    func countCompletedDays(for tracker: Tracker) -> Int {
        completedTrackers.filter({ $0.id == tracker.id }).count
    }
    
    func isTrackerCompleted(_ tracker: Tracker, date: Date) -> Bool {
        let trackerRecord = TrackerRecord(id: tracker.id, date: date)
        return completedTrackers.contains(trackerRecord)
    }
    
    func filterTrackersByDate(_ date: Date) {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let adjustedWeekday = AdjustedWeekday(rawValue: weekday)
        
        let currentDate = formatter.dateFormatter.string(from: date)
        
        var filter: [TrackerCategory] = []
        
        if let weekDayForm = adjustedWeekday?.weekDayForm {
            categories.forEach { category in
                let filteredTitle = category.title

                let filteredTrackers = category.trackers.filter { tracker in
                    tracker.schedule.count == 0 && tracker.creationDate == currentDate || tracker.schedule.contains(weekDayForm)
                }
                
                if !filteredTrackers.isEmpty {
                    filter.append(TrackerCategory(title: filteredTitle, trackers: filteredTrackers))
                }
            }
        }
        self.filteredCategories = filter
        view?.didFilterTrackersByDate()
    }

    // MARK: - Private Methods
    
    private func addToCompletedTrackers(tracker: Tracker, date: Date) {
        let trackerRecord = TrackerRecord(id: tracker.id, date: date)
        completedTrackers.insert(trackerRecord )
    }
    
    private func removeFromCompletedTrackers(tracker: Tracker, date: Date) {
        let trackerRecord = TrackerRecord(id: tracker.id, date: date)
        completedTrackers.remove(trackerRecord)
    }
}
