//
//  Tracker.swift
//  Tracker
//
//  Created by ulyana on 28.02.25.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
//    let isPinned: Bool
    let creationDate: String
}
