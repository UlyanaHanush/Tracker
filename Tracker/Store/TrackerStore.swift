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

struct TrackerStoreUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
}

protocol TrackerStoreDelegate: AnyObject {
    func store(
        _ store: TrackerStore,
        didUpdate update: TrackerStoreUpdate
    )
}

final class TrackerStore: NSObject {
    
    // MARK: - Constants
    
    private let context: NSManagedObjectContext
    private let uiColorMarshaling = UIColorMarshaling()
    private let daysValueTransformer = DaysValueTransformer()
    
    // MARK: - Publike Properties
    
    var tracker: [Tracker] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let tracker = try? objects.map({ try self.tracker(from: $0) })
        else {
            print("\(#file):\(#line)] \(#function) Ошибка получения tracker")
            return []
        }
        return tracker
    }
    
    weak var delegate: TrackerStoreDelegate?
    
    // MARK: - Private Properties
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    
    // MARK: - Initializers
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }

    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.date, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    // MARK: - Publike Methods
    
    func addNewTracker(_ tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        updateExistingTracker(trackerCoreData, with: tracker)
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // MARK: - Private Methods
    
    private func updateExistingTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
        trackerCoreData.name = tracker.name
        trackerCoreData.color = uiColorMarshaling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.id = tracker.id
        trackerCoreData.date = tracker.date
        trackerCoreData.schedule = daysValueTransformer.transformedValue(tracker.schedule) as? NSObject
    }

    private func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
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
//        guard let schedule = trackerCoreData.schedule else {
//            print("dead6")
//            throw TrackerStoreError.decodingErrorInvalidSchedule
//        }
        
        return Tracker(
            id: id,
            name: name,
            color: uiColorMarshaling.color(from: color),
            emoji: emoji,
            schedule: [WeekDay.monday], //  daysValueTransformer.reverseTransformedValue(schedule) as? [WeekDay] ??
            date: date
        )
    }
    
    func filterTrackersByDate(_ date: Date) {
        
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(
            self,
            didUpdate: TrackerStoreUpdate(
                insertedIndexes: insertedIndexes!,
                deletedIndexes: deletedIndexes!
            )
        )
        insertedIndexes = nil
        deletedIndexes = nil
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes?.insert(indexPath.item)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            deletedIndexes?.insert(indexPath.item)
        default:
            break
        }
    }
}
