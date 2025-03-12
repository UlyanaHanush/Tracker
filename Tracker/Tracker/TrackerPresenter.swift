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
    
    // MARK: - Publike Properties
    
    var view: TrackersViewControllerProtocol?
    var categories: [TrackerCategory] = [TrackerCategory(title: "good", trackers: [Tracker(id: UUID(), name: "Help mom", color: .red, emoji: "🌺", schedule: [1,2])])]
    
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
}
