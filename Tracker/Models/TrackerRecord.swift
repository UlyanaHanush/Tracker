//
//  TrackerRecord.swift
//  Tracker
//
//  Created by ulyana on 28.02.25.
//

import Foundation

struct TrackerRecord: Hashable {
    let id: UUID
    let date: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(Calendar.current.startOfDay(for: date))
    }
    
    static func == (lhs: TrackerRecord, rhs: TrackerRecord) -> Bool {
        return lhs.id == rhs.id &&
        Calendar.current.isDate(lhs.date, inSameDayAs: rhs.date)
    }
}
