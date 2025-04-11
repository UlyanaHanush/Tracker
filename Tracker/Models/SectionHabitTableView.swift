//
//  SectionHabitTableView.swift
//  Tracker
//
//  Created by ulyana on 8.03.25.
//

import Foundation

enum SectionHabitTableView: Int, CaseIterable {
    case textField
    case planning
    
    enum Row {
        case textField
        case category
        case schedule
    }
}
