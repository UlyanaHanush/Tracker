//
//  TrackerStore.swift
//  Tracker
//
//  Created by ulyana on 15.06.25.
//

import CoreData
import UIKit

enum TrackerStoreError: Error {
    case decodingErrorInvalidName
    case decodingErrorInvalidColor
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidId
    case decodingErrorInvalidDate
    case decodingErrorInvalidSchedule
}

final class TrackerStore {
    
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    private let daysValueTransformer = DaysValueTransformer()

    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchTracker() throws -> [Tracker] {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreDa
                                                           ta")
        TrackerDataModel.fetchRequest()
        let trackerFromCoreData = try context.fetch(fetchRequest)
        return try trackerFromCoreData.map { try self.tracker(from: $0) }
    }

    func addNewTracker(_ tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        updateExistingTracker(trackerCoreData, with: tracker)
        try context.save()
    }

    func updateExistingTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
        trackerCoreData.name = tracker.name
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.id = tracker.id
        trackerCoreData.date = tracker.date
        trackerCoreData.schedule = daysValueTransformer.transformedValue(tracker.schedule) as? NSObject
    }

    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let name = trackerCoreData.name else {
            throw TrackerStoreError.decodingErrorInvalidName
        }
        guard let color = trackerCoreData.color else {
            throw TrackerStoreError.decodingErrorInvalidColor
        }
        guard let emoji = trackerCoreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidEmoji
        }
        guard let id = trackerCoreData.id else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        guard let date = trackerCoreData.date else {
            throw TrackerStoreError.decodingErrorInvalidDate
        }
        guard let schedule = trackerCoreData.schedule else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }
        
        return Tracker(
            id: id,
            name: name,
            color: uiColorMarshalling.color(from: color),
            emoji: emoji,
            schedule: daysValueTransformer.reverseTransformedValue(schedule) as? [WeekDay] ?? [],
            date: date
        )
    }
}

