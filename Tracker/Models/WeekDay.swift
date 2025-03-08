//
//  WeekDay.swift
//  Tracker
//
//  Created by ulyana on 28.02.25.
//

import Foundation

enum WeekDay {
    case monday(dayNumber: Int = 1, longName: String = "Понедельник", shortName: String = "Пн")
    case tuesday(dayNumber: Int = 2, longName: String = "Вторник", shortName: String = "Вт")
    case wednesday(dayNumber: Int = 3, longName: String = "Среда", shortName: String = "Ср")
    case thursday(dayNumber: Int = 4, longName: String = "Четверг", shortName: String = "Чт")
    case friday(dayNumber: Int = 5, longName: String = "Пятница", shortName: String = "Пт")
    case saturday(dayNumber: Int = 6, longName: String = "Суббота", shortName: String = "Сб")
    case sunday(dayNumber: Int = 7, longName: String = "Воскресенье", shortName: String = "Вс")
    
//    var shortName: String {
//        switch self {
//        case .monday: return "Понедельник"
//        case .tuesday: return "Вторник"
//        case .wednesday: return "Среда"
//        case .thursday: return "Четверг"
//        case .friday: return "Пятница"
//        case .saturday: return "Суббота"
//        case .sunday: return "Воскресенье"
//        }
//        
//    }
//    
//    var shortForm: String {
//        switch self {
//        case .monday: return "Пн"
//        case .tuesday: return "Вт"
//        case .wednesday: return "Ср"
//        case .thursday: return "Чт"
//        case .friday: return "Пт"
//        case .saturday: return "Сб"
//        case .sunday: return "Вс"
//        }
//    }
}
