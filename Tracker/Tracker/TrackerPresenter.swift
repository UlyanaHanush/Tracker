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
    func didFilterTrackersByDate(_ date: Date) -> [TrackerCategory] 
}

final class TrackersPresenter: TrackersPresenterProtocol {
    
    // MARK: - Publike Properties
    
    var view: TrackersViewControllerProtocol?
    var completedTrackers: Set<TrackerRecord> = []
    var categories: [TrackerCategory] = []
    
    var search: String = ""
    var currentDate: Date = Date()
    var filteredCategories: [TrackerCategory] = []
    let formatter = Formatter()
    
    // MARK: - Initializers
    
    init() {
        let tracker = Tracker(id: UUID(), name: "Поливать растения", color: .red, emoji: "❤️", schedule: [.monday], creationDate: "14.03.2025")
        let category = TrackerCategory(title: "Домашний уют", trackers: [tracker])
        categories.append(category)
        
        let tracker1 = Tracker(id: UUID(), name: "Кошка заслонила камеру на созвоне", color: .green, emoji: "😻", schedule: [.friday, .monday], creationDate: "12.03.2025")
        let tracker2 = Tracker(id: UUID(), name: "Бабушка прислала открытку в вотсапеБабушка прислала открытку в вотсапе", color: .blue, emoji: "🌺", schedule: [.friday], creationDate: "14.03.2025")
        let tracker3 = Tracker(id: UUID(), name: "Свидания в апреле", color: .yellow, emoji: "❤️", schedule: [.sunday, .thursday], creationDate: "13.03.2025")
        let category2 = TrackerCategory(title: "Радостные мелочи", trackers: [tracker1, tracker2, tracker3])
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
        
        view?.didAddTracker()
    }
    
//    func updateCategories() -> [TrackerCategory] {
//       let weekday = currentDate.weekdayIndex
//       var result: [TrackerCategory] = []
//       for category in categories {
//           let trackers = search.isEmpty ? category.trackers.filter({ $0.schedule.contains(weekday) }) : category.trackers.filter({ $0.schedule.contains(weekday) && $0.name.contains(search) })
//           if !trackers.isEmpty {
//               let newCategory = TrackerCategory(title: category.title, trackers: trackers)
//               result.append(newCategory)
//           }
//       }
//       return result
//   }
    
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
    
    func didFilterTrackersByDate(_ date: Date) -> [TrackerCategory] {
        
        let currentDate = formatter.dateFormatter.string(from: date)

        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let adjustedWeekday = AdjustedWeekday(rawValue: weekday)
        
        if let weekDayForm = adjustedWeekday?.weekDayForm {
            categories.forEach { category in
                let filteredTitle = category.title

                let filteredTrackers = category.trackers.filter { tracker in
                    tracker.schedule.count == 0 && tracker.creationDate == currentDate || tracker.schedule.contains(weekDayForm)
                }
                
                if !filteredTrackers.isEmpty {
                    filteredCategories.append(TrackerCategory(title: filteredTitle, trackers: filteredTrackers))
                }
            }
        }
        return filteredCategories
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
