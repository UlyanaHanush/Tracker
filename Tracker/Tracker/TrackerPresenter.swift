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
    
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    // MARK: - Publike Properties
    
    weak var view: TrackersViewControllerProtocol?
    var completedTrackers: Set<TrackerRecord> = []
    var categories: [TrackerCategory] = []
    var search: String = ""
    var currentDate: Date = Date().ignoringTime
    var filteredCategories: [TrackerCategory] = []
    
    var visibleTracker: [Tracker] = []
    
    // MARK: - Initializers
    
    init() {
        let tracker = Tracker(id: UUID(), name: "Помочь бабушке", color: .red, emoji: "❤️", schedule: [.monday], date: Date())
        let category = TrackerCategory(title: "Обязательства перед семьей", trackers: [tracker])
        categories.append(category)
        
        let tracker1 = Tracker(id: UUID(), name: "Сходить в бассейн", color: .green, emoji: "😻", schedule: [.friday, .tuesday], date: Date())
        let tracker2 = Tracker(id: UUID(), name: "Устроить бьюти день", color: .blue, emoji: "🌺", schedule: [.thursday, .saturday], date: Date())
        let tracker3 = Tracker(id: UUID(), name: "Занятия теннисом", color: .yellow, emoji: "❤️", schedule: [.sunday, .wednesday, .friday], date:  Date())
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
        
        //try! trackerStore.addNewTracker(tracker)
        view?.didAddTracker()
    }
    
    func completeTracker(_ tracker: Tracker, date: Date) {
        if isTrackerEmpty(tracker, date: date) {
            addToCompletedTrackers(tracker: tracker, date: currentDate)
        } else {
            removeFromCompletedTrackers(tracker: tracker, date: currentDate)
        }
    }
    
    func countCompletedDays(for tracker: Tracker) -> Int {
        trackerRecordStore.countCompletedDays(for: tracker)
        
        //completedTrackers.filter({ $0.id == tracker.id }).count
    }
    
    func isTrackerEmpty(_ tracker: Tracker, date: Date) -> Bool {
        let trackerRecord = TrackerRecord(id: tracker.id, date: date)
        return trackerRecordStore.isTrackerEmpty(trackerRecord)
        
       //return completedTrackers.contains(trackerRecord)
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
                    tracker.schedule.count == 0 && formatter.dateFormatter.string(from: tracker.date) == currentDate || tracker.schedule.contains(weekDayForm)
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
        try! trackerRecordStore.addRecord(trackerRecord)
        
        //completedTrackers.insert(trackerRecord )
    }
    
    private func removeFromCompletedTrackers(tracker: Tracker, date: Date) {
        let trackerRecord = TrackerRecord(id: tracker.id, date: date)
        try! trackerRecordStore.deleteRecord(trackerRecord)
        
        //completedTrackers.remove(trackerRecord)
    }
}
