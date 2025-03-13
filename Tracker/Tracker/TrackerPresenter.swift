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
    var completedTrackers: [TrackerRecord] { get set }
    func addTracker(_ tracker: Tracker, at category: TrackerCategory)
}

final class TrackersPresenter: TrackersPresenterProtocol {
    
    // MARK: - Publike Properties
    
    var completedTrackers: [TrackerRecord] = []
    
    var view: TrackersViewControllerProtocol?
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
    var categories: [TrackerCategory] = []
    
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
    
    func completeTracker(_ complete: Bool, tracker: Tracker) {
         if complete {
             addToCompletedTrackers(tracker: tracker, date: currentDate)
         } else {
             removeFromCompletedTrackers(tracker: tracker, date: currentDate)
         }
     }
    
    func addToCompletedTrackers(tracker: Tracker, date: Date) {
        var completedTrackers = self.completedTrackers
        let trackerToRecord = TrackerRecord(id: tracker.id, date: date)
        completedTrackers.append(trackerToRecord)
        self.completedTrackers = completedTrackers
        
    }
    
    func removeFromCompletedTrackers(tracker: Tracker, date: Date) {
        var completedTrackers = self.completedTrackers
        let trackerToRemove = TrackerRecord(id: tracker.id, date: date)
        guard let index = completedTrackers.firstIndex(where: {$0.id == trackerToRemove.id}) else { return }
        completedTrackers.remove(at: index)
        self.completedTrackers = completedTrackers
    }
    
    func isCompletedTracker(_ tracker: Tracker) -> Bool {
        completedTrackers.first(where: { $0.id == tracker.id && $0.date == currentDate }) != nil
    }
    
    func countRecordsTracker(_ tracker: Tracker) -> Int {
        completedTrackers.filter({ $0.id == tracker.id }).count
    }
}

extension Date {
    var weekdayIndex: Int {
        Calendar.current.component(.weekday, from: self) - 1
    }
}
