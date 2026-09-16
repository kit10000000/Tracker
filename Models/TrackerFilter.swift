//
//  TrackerFilter.swift
//  Tracker
//
//  Created by Ekaterina on 16.09.2026.
//

import Foundation

enum TrackerFilter: Int, CaseIterable {
    case all, today, completed, uncompleted

    var title: String {
        switch self {
        case .all:         return NSLocalizedString("filter.all", comment: "")
        case .today:       return NSLocalizedString("filter.today", comment: "")
        case .completed:   return NSLocalizedString("filter.completed", comment: "")
        case .uncompleted: return NSLocalizedString("filter.uncompleted", comment: "")
        }
    }
}
