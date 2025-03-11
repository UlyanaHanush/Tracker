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
    var schedule: [Int] { get set }
}

final class HabitCreatingPresenter: HabitCreatingPresenterProtocol {
    
    // MARK: - Publike Properties
    
    var view: HabitCreatingViewControllerProtocol?
    var trackerType: TrackerType
    var delegate: HabitCreatingDelegate?
    var schedule: [Int] = []
    
    init(trackerType: TrackerType) {
        self.trackerType = trackerType
    }
}
