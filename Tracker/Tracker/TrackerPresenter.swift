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
}

final class TrackersPresenter: TrackersPresenterProtocol {
    
    // MARK: - Constants
    
    let formatter = Formatter()
    
    private let trackerStore = TrackerStore.shared
    private let trackerRecordStore = TrackerRecordStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    
    // MARK: - Publike Properties
    
    weak var view: TrackersViewControllerProtocol?
    var categories: [TrackerCategory] = []
    var search: String = ""
    var currentDate: Date = Date().ignoringTime
    
    // MARK: - Initializers
    
    init() {
        let category = TrackerCategory(title: "Обязательства перед семьей", trackers: [])
        categories.append(category)
    }
    
    // MARK: - Publike Methods
    
    func addTracker(_ tracker: Tracker, at category: TrackerCategory) {
        try! trackerStore.addNewTracker(tracker)
        try! trackerCategoryStore.addCategory(name: category.title)

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
