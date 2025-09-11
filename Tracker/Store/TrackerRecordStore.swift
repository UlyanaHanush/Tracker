//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by ulyana on 17.06.25.
//

import CoreData
import UIKit

enum TrackerRecordStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidDate
    case deleteRecordError
}

protocol TrackerRecordStoreDelegate: AnyObject {
    func store(
        _ store: TrackerRecordStore,
        didUpdate update: TrackerRecordStoreUpdate
    )
}

struct TrackerRecordStoreUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
}

final class TrackerRecordStore: NSObject {
    
    // MARK: - Constants
    
    private let context: NSManagedObjectContext
    
    // MARK: - Publike Properties
    
    var trackerRecord: [TrackerRecord] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackerRecord = try? objects.map({ try self.trackerRecord(from: $0) })
        else {
            print("\(#file):\(#line)] \(#function) Ошибка получения trackerRecord")
            return []
        }
        return trackerRecord
    }
    
    weak var delegate: TrackerRecordStoreDelegate?
    
    // MARK: - Private Properties
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!
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
        
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.recordId, ascending: true)
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
    
    // MARK: - Public Methods
    
    func trackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = trackerRecordCoreData.recordId else {
            throw TrackerRecordStoreError.decodingErrorInvalidId
        }
        
        guard let data = trackerRecordCoreData.recordData else {
            throw TrackerRecordStoreError.decodingErrorInvalidDate
        }
        
        return TrackerRecord(
            id: id,
            date: data
        )
    }
    
    func addRecord(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.recordId = trackerRecord.id
        
        trackerRecordCoreData.recordData = trackerRecord.date
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("\(#file):\(#line)] \(#function) Ошибка сохранения категории")
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func deleteRecord(_ trackerRecord: TrackerRecord) throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.recordId), trackerRecord.id.uuidString)
        let datePredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.recordData), trackerRecord.date as NSDate)
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [idPredicate, datePredicate])
        
        if let existingTracker = try? context.fetch(request).first {
            do {
                context.delete(existingTracker)
                try context.save()
            } catch {
                print("\(#file):\(#line)] \(#function) Ошибка удаления TrackerRecord")
                throw TrackerRecordStoreError.deleteRecordError
            }
        }
    }
    
    func countCompletedDays(for tracker: Tracker) -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.recordId), tracker.id.uuidString)
        
        request.predicate = idPredicate
        let trackerRecord = try! context.fetch(request)
        
        let countCompletedDays = trackerRecord.count
        return countCompletedDays
    }
    
    func isTrackerEmpty(_ trackerRecord : TrackerRecord) -> Bool {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        let tracker = try? context.fetch(request)
        
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.recordId), trackerRecord.id.uuidString)
        let datePredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.recordData), trackerRecord.date as NSDate)
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [idPredicate, datePredicate])
        
        let completedTrackers = try! context.fetch(request)
        //print(completedTrackers.first?.recordData ?? "")
        
        let isTrackerCompleted = completedTrackers.isEmpty
        return isTrackerCompleted
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(
            self,
            didUpdate: TrackerRecordStoreUpdate(
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


