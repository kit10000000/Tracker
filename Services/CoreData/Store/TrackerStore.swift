//
//  TrackerStore.swift
//  Tracker
//
//  Created by Ekaterina on 04.09.2026.
//

import Foundation
import CoreData

enum TrackerStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidTitle
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidColor
    case decodingErrorInvalidSchedule
    case trackerDoesntExist
}

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
        try? self.context.save()
    }

    func trackerCoreData(forId id: UUID) throws -> TrackerCoreData {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let found = try? context.fetch(request).first else { throw TrackerStoreError.trackerDoesntExist }
        return found
    }

    static func tracker(from coreData: TrackerCoreData) throws -> Tracker {
        guard let id = coreData.id else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        guard let title = coreData.title else {
            throw TrackerStoreError.decodingErrorInvalidTitle
        }
        guard let emoji = coreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidEmoji
        }
        guard let color = coreData.color else {
            throw TrackerStoreError.decodingErrorInvalidColor
        }
        guard let schedule = coreData.schedule else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }
        return Tracker(id: id, title: title, color: color, emoji: emoji, schedule: schedule as? [WeekDay] ?? [])
    }
}
