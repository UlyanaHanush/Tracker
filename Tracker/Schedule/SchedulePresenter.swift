//
//  SchedulePresenter.swift
//  Tracker
//
//  Created by ulyana on 9.03.25.
//

import Foundation

protocol SchedulePresenterProtocol {
    var view: ScheduleViewControllerProtocol? { get }
    var selectedWeekDays: [String:Bool] { get set }
    func getWeekDays() -> [String]
}

final class SchedulePresenter: SchedulePresenterProtocol {
    
    // MARK: - Publike Properties
    
    var view: ScheduleViewControllerProtocol?
    
    var selectedWeekDays = [String:Bool]()
    
    func getWeekDays() -> [String] {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru_Ru")
        calendar.firstWeekday = 3
        let weekdays = calendar.weekdaySymbols
        return weekdays
    }
}

