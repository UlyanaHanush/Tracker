//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by ulyana on 17.06.25.
//

import CoreData
import UIKit

protocol TrackerCategoryStoreDelegate: AnyObject {
    func store(
        _ store: TrackerCategoryStore,
        didUpdate update: TrackerCategoryStoreUpdate
    )
}

class TrackerCategoryStore: NSObject {
    
    // MARK: - Constants
    
    private let context: NSManagedObjectContext
    
    // MARK: - Publike Properties
    
    var trackerCategory: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackerCategory = try? objects.map({ try self.trackerCategory(from: $0) })
        else {
            print("\(#file):\(#line)] \(#function) Ошибка получения trackerCategory")
            return []
        }
        return trackerCategory
    }
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    // MARK: - Private Properties
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
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
        
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
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
    
    func trackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCoreData.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }
        
        return TrackerCategory(
            //TODO нужно будет добавить связь
            title: title,
            trackers: []
        )
    }
    
    func addCategory(name: String) throws {
        do {
            let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
            trackerCategoryCoreData.title = name
            trackerCategoryCoreData.trackers = []
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
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {}
