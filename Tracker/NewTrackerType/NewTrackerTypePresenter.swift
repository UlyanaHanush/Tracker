//
//  NewTrackerTypePresenter.swift
//  Tracker
//
//  Created by ulyana on 8.03.25.
//

import Foundation

protocol NewTrackerTypePresenterProtocol {
    var view: TrackerTypeViewControllerProtocol? { get }
    func selectType(_ type: TrackerType)
}

class NewTrackerTypePresenter: NewTrackerTypePresenterProtocol {
    
    var view: TrackerTypeViewControllerProtocol?
    var delegate: TrackerTypeDelegate?
    func selectType(_ type: TrackerType) {
        delegate?.didSelectType(type)
    }
}
