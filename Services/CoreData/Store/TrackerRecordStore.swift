//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Ekaterina on 04.09.2026.
//

import CoreData

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
        let request = TrackerRecordCoreData.fetchRequest()
        let result = context.fetchOrEmpty(request)
        return result.compactMap { try? $0.toDomain() }
    }

    func toggleRecord(for trackerId: UUID, on date: Date) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) else { return }

        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@ AND %K >= %@ AND %K < %@",
            "tracker.id", trackerId as CVarArg,
            #keyPath(TrackerRecordCoreData.date), startOfDay as NSDate,
            #keyPath(TrackerRecordCoreData.date), nextDay as NSDate
        )

        if let found = context.fetchOrEmpty(request).first {
            context.delete(found)
        } else {
            guard let tracker = try? trackerStore.trackerCoreData(forId: trackerId) else { return }
            let newRecord = TrackerRecordCoreData(context: self.context)
            newRecord.date = date
            newRecord.tracker = tracker
        }

        self.context.saveChanges()
    }
}
