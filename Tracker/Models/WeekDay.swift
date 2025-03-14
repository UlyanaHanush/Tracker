//
//  WeekDay.swift
//  Tracker
//
//  Created by ulyana on 28.02.25.
//

import Foundation

enum WeekDay: Int, CaseIterable {
    case sunday = 6
    case monday = 0
    case tuesday = 1
    case wednesday = 2
    case thursday = 3
    case friday = 4
    case saturday = 5
    
    var shortName: String {
        switch self {
        case .sunday: return "Воскресенье"
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        }
    }
    
    var shortForm: String {
        switch self {
        case .sunday: return "Вс"
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        }
    }
}

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
