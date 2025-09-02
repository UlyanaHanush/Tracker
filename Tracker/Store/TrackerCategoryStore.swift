//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by ulyana on 17.06.25.
//

import Foundation
import CoreData
import UIKit

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTrackerCategoryData
    case createCategoryError
}

final class TrackerCategoryStore {
    
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()

    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }


    
    
    
//    // MARK: - Public Methods
//    func getCategoryTitle() -> [String] {
//        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
//        request.propertiesToFetch = ["title"]
//        let categoryTitle = try? context.fetch(request)
//        return categoryTitle?.map { $0.title } ?? []
//    }
//        
//    func getCategoryWithName(_ name: String) -> TrackerCategoryCoreData? {
//        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
//        let namePredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.name), name)
//        request.predicate = namePredicate
//        return try? context.fetch(request).first
//    }
//        
//    func addCategory(name: String) throws {
//        do {
//            let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
//            trackerCategoryCoreData.title = name
//            trackerCategoryCoreData.trackers = []
//            try context.save()
//        } catch {
//            print(error)
//            throw TrackerCategoryStoreError.createCategoryError
//        }
//    }
}
