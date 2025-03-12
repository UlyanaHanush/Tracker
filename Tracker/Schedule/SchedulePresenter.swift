//
//  SchedulePresenter.swift
//  Tracker
//
//  Created by ulyana on 9.03.25.
//

import Foundation

protocol SchedulePresenterProtocol {
    var view: ScheduleViewControllerProtocol? { get }
    var selectedWeekdays: [Int] { get set }
    func getWeekDays() -> [String]
    func done()
}

final class SchedulePresenter: SchedulePresenterProtocol {
    
    // MARK: - Publike Properties
    
    var view: ScheduleViewControllerProtocol?
    var delegate: ScheduleDelegate?
    
    var selectedWeekdays: [Int]
    
    init(view: ScheduleViewControllerProtocol, selectedWeekdays: [Int], delegate: ScheduleDelegate) {
          self.view = view
          self.delegate = delegate
          self.selectedWeekdays = selectedWeekdays
      }
    
    func getWeekDays() -> [String] {

        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru_Ru")
        calendar.firstWeekday = 2
        
        let weekdays = calendar.weekdaySymbols
        var weekday = weekdays.map { $0.capitalized }
        let sunday = weekday[0]
        weekday.remove(at: 0)
        weekday.append(sunday)
        return weekday
    }
    
    func done() {
        delegate?.didSelect(weekdays: selectedWeekdays)
    }
}

