//
//  HabitCreatingPresenter.swift
//  Tracker
//
//  Created by ulyana on 8.03.25.
//

import Foundation

protocol HabitCreatingPresenterProtocol {
    var view: HabitCreatingViewControllerProtocol? { get }
    
    var trackerType: TrackerType { get set }
    
    var trackerName: String? { get set }
    var selectedCategory: TrackerCategory? { get }
    var schedule: [Int] { get set }
    
    func isValidForm() -> Bool
    
    func createNewTracker()
}

final class HabitCreatingPresenter: HabitCreatingPresenterProtocol {
    
    // MARK: - Publike Properties
    
    var view: HabitCreatingViewControllerProtocol?
    var trackerType: TrackerType
    var delegate: HabitCreatingDelegate?
    var schedule: [Int] = []
    var trackerName: String?
    
    var selectedCategory: TrackerCategory?
 
    var categories: [TrackerCategory]
    
    
    
    init(trackerType: TrackerType, categories: [TrackerCategory]) {
        self.trackerType = trackerType
        self.categories = categories
        self.selectedCategory = categories.first
    }
    
    func isValidForm() -> Bool {
        switch trackerType {
        case .Habit:
            return selectedCategory != nil && trackerName != nil && !schedule.isEmpty
        case .UnRegularEvent:
            return selectedCategory != nil && trackerName != nil
        }
    }
    
    func createNewTracker() {
        guard let name = trackerName, let selectedCategory else { return }
        
        let newTracker = Tracker(id: UUID(), name: name, color: .red, emoji: "🌺", schedule: schedule)
    
        delegate?.didCreateTracker(newTracker, at: selectedCategory)
    }
}
