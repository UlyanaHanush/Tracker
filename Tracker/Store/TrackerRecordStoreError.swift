//
//  TrackerRecordStoreError.swift
//  Tracker
//
//  Created by ulyana on 18.09.25.
//

import Foundation

enum TrackerRecordStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidDate
    case deleteRecordError
}
