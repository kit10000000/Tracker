//
//  TrackerRecordStorage.swift
//  Tracker
//
//  Created by Ekaterina on 21.08.2026.
//

import Foundation

final class TrackerRecordStorage {

    // MARK: - Properties

    static let shared = TrackerRecordStorage()
    private(set) var completedTrackers: [TrackerRecord] = []

    // MARK: - Initializers

    private init() {}

    // MARK: - Methods

    func toggleRecord(for trackerId: UUID, on date: Date) {
        if let index = completedTrackers.firstIndex(where: {
            $0.trackerId == trackerId && Calendar.current.isDate($0.date, inSameDayAs: date)
        }) {
            completedTrackers.remove(at: index)
        } else {
            completedTrackers.append(TrackerRecord(trackerId: trackerId, date: date))
        }
    }
}
