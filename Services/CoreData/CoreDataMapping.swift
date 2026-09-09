//
//  CoreDataMapping.swift
//  Tracker
//
//  Created by Ekaterina on 08.09.2026.
//

import Foundation
import CoreData

enum CoreDataMappingError: Error {
    case missingId
    case missingTitle
    case missingEmoji
    case missingColor
    case missingSchedule
    case missingTrackerId
    case missingDate
}

extension TrackerCoreData {
    func toDomain() throws -> Tracker {
        guard let id else { throw CoreDataMappingError.missingId }
        guard let title else { throw CoreDataMappingError.missingTitle }
        guard let emoji else { throw CoreDataMappingError.missingEmoji }
        guard let color else { throw CoreDataMappingError.missingColor }
        guard let schedule else { throw CoreDataMappingError.missingSchedule }
        return Tracker(id: id, title: title, color: color, emoji: emoji, schedule: schedule as? [WeekDay] ?? [])
    }
}

extension TrackerCategoryCoreData {
    func toDomain() throws -> TrackerCategory {
        guard let title else { throw CoreDataMappingError.missingTitle }
        let trackers = try (trackers?.allObjects as? [TrackerCoreData] ?? [])
            .sorted { ($0.title ?? "") < ($1.title ?? "") }
            .map { try $0.toDomain() }
        return TrackerCategory(title: title, trackers: trackers)
    }
}

extension TrackerRecordCoreData {
    func toDomain() throws -> TrackerRecord {
        guard let trackerId = tracker?.id else { throw CoreDataMappingError.missingTrackerId }
        guard let date else { throw CoreDataMappingError.missingDate }
        return TrackerRecord(trackerId: trackerId, date: date)
    }
}
