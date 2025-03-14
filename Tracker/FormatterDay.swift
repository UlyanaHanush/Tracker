//
//  FormatterDay.swift
//  Tracker
//
//  Created by ulyana on 14.03.25.
//

import Foundation

final class Formatter {
    
    // MARK: - Private Properties
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        formatter.locale = Locale(identifier: "ru")
        return formatter
    }()
}

extension Date {
    var ignoringTime: Date? {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru_RU")
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: self)
        return calendar.date(from: dateComponents)
    }
}
