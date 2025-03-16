//
//  AdjustedWeekday.swift
//  Tracker
//
//  Created by ulyana on 16.03.25.
//

import Foundation

enum AdjustedWeekday: Int {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    var weekDayForm: WeekDay {
        switch self {
        case .sunday: return WeekDay.sunday
        case .monday: return WeekDay.monday
        case .tuesday: return WeekDay.tuesday
        case .wednesday: return WeekDay.wednesday
        case .thursday: return WeekDay.tuesday
        case .friday: return WeekDay.friday
        case .saturday: return WeekDay.saturday
        }
    }
}
