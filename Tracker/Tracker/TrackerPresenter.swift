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
}

final class TrackersPresenter: TrackersPresenterProtocol {
    
    // MARK: - Publike Properties
    
    var view: TrackersViewControllerProtocol?
    var completedTrackers: Set<TrackerRecord> = []
    var categories: [TrackerCategory] = []
    
    var search: String = "" {
        didSet {
            updateCategories()
        }
    }
    var currentDate: Date = Date() {
        didSet {
            updateCategories()
        }
    }
    
    init() {
        let tracker = Tracker(id: UUID(), name: "Поливать растения", color: .red, emoji: "❤️", schedule: [2])
        let category = TrackerCategory(title: "Домашний уют", trackers: [tracker])
        categories.append(category)
        
        let tracker1 = Tracker(id: UUID(), name: "Кошка заслонила камеру на созвоне", color: .green, emoji: "😻", schedule: [3, 2])
        let tracker2 = Tracker(id: UUID(), name: "Бабушка прислала открытку в вотсапеБабушка прислала открытку в вотсапе", color: .blue, emoji: "🌺", schedule: [2])
        let tracker3 = Tracker(id: UUID(), name: "Свидания в апреле", color: .yellow, emoji: "❤️", schedule: [3, 2])
        let category2 = TrackerCategory(title: "Радостные мелочи", trackers: [tracker1, tracker2, tracker3])
        categories.append(category2)
    }
    
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
    }
    
    func updateCategories() -> [TrackerCategory] {
       let weekday = currentDate.weekdayIndex
       var result: [TrackerCategory] = []
       for category in categories {
           let trackers = search.isEmpty ? category.trackers.filter({ $0.schedule.contains(weekday) }) : category.trackers.filter({ $0.schedule.contains(weekday) && $0.name.contains(search) })
           if !trackers.isEmpty {
               let newCategory = TrackerCategory(title: category.title, trackers: trackers)
               result.append(newCategory)
           }
       }
       return result
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
    
    // MARK: - Private Methods
    
    private func addToCompletedTrackers(tracker: Tracker, date: Date) {
        let trackerRecord = TrackerRecord(id: tracker.id, date: date)
        completedTrackers.insert(trackerRecord )
        print("\(#file):\(#line)] \(#function) Добавлен трекер: \(tracker.name) на дату: \(date)")
        //collectionView.reloadData()
    }
    
    private func removeFromCompletedTrackers(tracker: Tracker, date: Date) {
        let trackerRecord = TrackerRecord(id: tracker.id, date: date)
        completedTrackers.remove(trackerRecord)
        print("\(#file):\(#line)] \(#function) Удален трекер: \(tracker.name) с даты: \(date)")
        //collectionView.reloadData()
    }
}

extension Date {
    var weekdayIndex: Int {
        Calendar.current.component(.weekday, from: self) - 1
    }
}
