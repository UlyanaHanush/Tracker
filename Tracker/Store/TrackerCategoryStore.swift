//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by ulyana on 17.06.25.
//

import CoreData
import UIKit

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTitle
}

final class TrackerCategoryStore {
    
    private let context: NSManagedObjectContext

    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchTrackerCategory() throws -> [TrackerCategory] {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        let trackerCategoryFromCoreData = try context.fetch(fetchRequest)
        return try trackerCategoryFromCoreData.map { try self.trackerCategory(from: $0) }
    }

    func addNewTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        updateExistingTrackerCategory(trackerCategoryCoreData, with: trackerCategory)
        try context.save()
    }

    func updateExistingTrackerCategory(_ trackerCategoryCoreData: TrackerCategoryCoreData, with trackerCategory: TrackerCategory) {
        trackerCategoryCoreData.title = trackerCategory.title
    }

    func trackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCoreData.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }
        
        return trackerCategory(title: title)
    }
}
