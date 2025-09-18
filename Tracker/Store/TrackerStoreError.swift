//
//  TrackerStoreError.swift
//  Tracker
//
//  Created by ulyana on 18.09.25.
//

import Foundation

enum TrackerStoreError: Error {
    case decodingErrorInvalidName
    case decodingErrorInvalidColor
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidId
    case decodingErrorInvalidDate
    case decodingErrorInvalidSchedule
}
