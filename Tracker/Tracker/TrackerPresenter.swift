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
    func addTracker(_ tracker: Tracker, at category: TrackerCategory)
    func filterTrackersByDate(_ date: Date)
}

final class TrackersPresenter: TrackersPresenterProtocol {
    
    // MARK: - Constants
    
    let formatter = Formatter()
    
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    
    // MARK: - Publike Properties
    
    weak var view: TrackersViewControllerProtocol?
    var categories: [TrackerCategory] = []
    var search: String = ""
    var currentDate: Date = Date().ignoringTime
    var filteredCategories: [TrackerCategory] = []
    
    var visibleTracker: [Tracker] = []
    
    // MARK: - Initializers
    
    init() {
        let tracker = Tracker(id: UUID(), name: "Помочь бабушке", color: .red, emoji: "❤️", schedule: "1", date: Date())
        let category = TrackerCategory(title: "Обязательства перед семьей", trackers: [tracker])
        categories.append(category)
        
        let tracker1 = Tracker(id: UUID(), name: "Сходить в бассейн", color: .green, emoji: "😻", schedule: "2", date: Date())
        let tracker2 = Tracker(id: UUID(), name: "Устроить бьюти день", color: .blue, emoji: "🌺", schedule: "3", date: Date())
        let tracker3 = Tracker(id: UUID(), name: "Занятия теннисом", color: .yellow, emoji: "❤️", schedule: "4", date:  Date())
        let category2 = TrackerCategory(title: "Красота", trackers: [tracker1, tracker2, tracker3])
        categories.append(category2)
    }
    
    // MARK: - Publike Methods
    
    func addTracker(_ tracker: Tracker, at category: TrackerCategory) {
        
//        try! trackerStore.addNewTracker(tracker)
//        try! trackerCategoryStore.addCategory(name: category.title)
        
        filterTrackersByDate(currentDate)

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
    }
    
    func isTrackerEmpty(_ tracker: Tracker, date: Date) -> Bool {
        let trackerRecord = TrackerRecord(id: tracker.id, date: date)
        return trackerRecordStore.isTrackerEmpty(trackerRecord)
    }
    
    func filterTrackersByDate(_ date: Date) {
        visibleTracker = trackerStore.filterTrackersByDate(date)
        view?.didFilterTrackersByDate()
    }
    
    // MARK: - Private Methods
    
    private func addToCompletedTrackers(tracker: Tracker, date: Date) {
        let trackerRecord = TrackerRecord(id: tracker.id, date: date)
        try! trackerRecordStore.addRecord(trackerRecord)
    }
    
    private func removeFromCompletedTrackers(tracker: Tracker, date: Date) {
        let trackerRecord = TrackerRecord(id: tracker.id, date: date)
        try! trackerRecordStore.deleteRecord(trackerRecord)
    }
    
    private func weekDay(from date: Date) -> WeekDay {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let adjustedWeekday = AdjustedWeekday(rawValue: weekday)
        guard let weekDayForm = adjustedWeekday?.weekDayForm else { return WeekDay.monday }
        return weekDayForm
    }
}
