//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Ekaterina on 04.09.2026.
//

import Foundation
import CoreData

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTitle
}

final class TrackerCategoryStore {

    // MARK: - Private Properties

    private let context: NSManagedObjectContext

    // MARK: - Initializers

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    // MARK: - Methods

    func addCategory(title: String) {
        let newCategory = TrackerCategoryCoreData(context: self.context)
        newCategory.title = title
        try? self.context.save()
    }

    func categories() -> [TrackerCategory] {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let result = (try? context.fetch(request)) ?? []
        return result.compactMap { try? self.trackerCategory(from: $0) }
    }

    func titles() -> [String] {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let result = (try? context.fetch(request)) ?? []
        return result.compactMap { $0.title }
    }

    func trackerCategory(from coreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = coreData.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }
        let trackerCoreData = coreData.trackers?.allObjects as? [TrackerCoreData] ?? []
        let trackers = try trackerCoreData.map { try TrackerStore.tracker(from: $0) }
        return TrackerCategory(title: title, trackers: trackers)
    }

    func categoryCoreData(forTitle: String) -> TrackerCategoryCoreData {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "title == %@", forTitle)

        if let found = try? context.fetch(request).first { return found }

        let category = TrackerCategoryCoreData(context: self.context)
        category.title = forTitle
        return category
    }
}
