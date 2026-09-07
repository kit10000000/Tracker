//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Ekaterina on 04.09.2026.
//

import Foundation
import CoreData

enum TrackerRecordStoreError: Error {
    case decodingErrorInvalidTrackerId
    case decodingErrorInvalidDate
}

final class TrackerRecordStore {

    // MARK: - Private Properties

    private let context: NSManagedObjectContext
    private let trackerStore: TrackerStore

    // MARK: - Initializers

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
        self.trackerStore = TrackerStore(context: context)
    }

    // MARK: - Methods

    func records() -> [TrackerRecord] {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let result = (try? context.fetch(request)) ?? []
        return result.compactMap { try? self.trackerRecord(from: $0) }
    }

    func trackerRecord(from coreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let trackerId = coreData.tracker?.id else {
            throw TrackerRecordStoreError.decodingErrorInvalidTrackerId
        }
        guard let date = coreData.date else {
            throw TrackerRecordStoreError.decodingErrorInvalidDate
        }
        return TrackerRecord(trackerId: trackerId, date: date)
    }

    func toggleRecord(for trackerId: UUID, on date: Date) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) else { return }

        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(
            format: "tracker.id == %@ AND date >= %@ AND date < %@",
            trackerId as CVarArg,
            startOfDay as NSDate,
            nextDay as NSDate
        )

        if let found = try? context.fetch(request).first {
            context.delete(found)
        } else {
            guard let tracker = try? trackerStore.trackerCoreData(forId: trackerId) else { return }
            let newRecord = TrackerRecordCoreData(context: self.context)
            newRecord.date = date
            newRecord.tracker = tracker
        }

        try? self.context.save()
    }
}
