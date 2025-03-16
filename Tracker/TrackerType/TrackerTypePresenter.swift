//
//  NewTrackerTypePresenter.swift
//  Tracker
//
//  Created by ulyana on 8.03.25.
//

import Foundation

protocol TrackerTypePresenterProtocol {
    var view: TrackerTypeViewControllerProtocol? { get }
    func selectType(_ type: TrackerType)
}

final class TrackerTypePresenter: TrackerTypePresenterProtocol {
    
    // MARK: - Publike Properties
    
    weak var view: TrackerTypeViewControllerProtocol?
    var delegate: TrackerTypeDelegate?
    
    // MARK: - Publike Methods
    
    func selectType(_ type: TrackerType) {
        delegate?.didSelectType(type)
    }
}
