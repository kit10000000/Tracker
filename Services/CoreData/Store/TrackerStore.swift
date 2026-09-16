//
//  TrackerStore.swift
//  Tracker
//
//  Created by Ekaterina on 04.09.2026.
//

import CoreData

final class TrackerStore {

    // MARK: - Private Properties

    private let context: NSManagedObjectContext
    private let categoryStore: TrackerCategoryStore

    // MARK: - Initializers

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
        self.categoryStore = TrackerCategoryStore(context: context)
    }

    // MARK: - Methods

    func addTracker(_ tracker: Tracker, toCategory title: String) {
        let newTracker = TrackerCoreData(context: self.context)
        newTracker.title = tracker.title
        newTracker.color = tracker.color
        newTracker.emoji = tracker.emoji
        newTracker.schedule = tracker.schedule as NSObject?
        newTracker.category = categoryStore.categoryCoreData(forTitle: title)
        newTracker.id = tracker.id
        self.context.saveChanges()
    }

    func deleteTracker(_ id: UUID) throws {
        let found = try trackerCoreData(forId: id)
        context.delete(found)
        context.saveChanges()
    }

    func updateTracker(_ tracker: Tracker, toCategory title: String) throws {
        let found = try trackerCoreData(forId: tracker.id)
        found.color = tracker.color
        found.emoji = tracker.emoji
        found.title = tracker.title
        found.category = categoryStore.categoryCoreData(forTitle: title)
        found.schedule = tracker.schedule as NSObject?
        context.saveChanges()
    }

    func trackerCoreData(forId id: UUID) throws -> TrackerCoreData {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        guard let found = context.fetchOrEmpty(request).first else { throw StoreError.entityDoesntExist }
        return found
    }
}
