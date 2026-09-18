//
//  TrackerDraft.swift
//  Tracker
//
//  Created by Ekaterina on 15.09.2026.
//

import Foundation

struct TrackerDraft {
    var id: UUID?
    var name = ""
    var emoji: String?
    var color: String?
    var schedule: [WeekDay] = []
    var category = ""

    var isComplete: Bool {
        !name.isEmpty
        && !schedule.isEmpty
        && emoji?.isEmpty == false
        && color?.isEmpty == false
        && !category.isEmpty
    }
}
