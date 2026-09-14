//
//  WeekDay.swift
//  Tracker
//
//  Created by Ekaterina on 05.08.2026.
//

import Foundation

enum WeekDay: Int, CaseIterable, Codable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday

    init?(date: Date, calendar: Calendar = .current) {
        let systemWeekday = calendar.component(.weekday, from: date)
        self.init(rawValue: systemWeekday == 1 ? 7 : systemWeekday - 1)
    }

    var shortName: String {
        switch self {
        case .monday: NSLocalizedString("weekday.monday.short", comment: "Short name for Monday")
        case .tuesday: NSLocalizedString("weekday.tuesday.short", comment: "Short name for Tuesday")
        case .wednesday: NSLocalizedString("weekday.wednesday.short", comment: "Short name for Wednesday")
        case .thursday: NSLocalizedString("weekday.thursday.short", comment: "Short name for Thursday")
        case .friday: NSLocalizedString("weekday.friday.short", comment: "Short name for Friday")
        case .saturday: NSLocalizedString("weekday.saturday.short", comment: "Short name for Saturday")
        case .sunday: NSLocalizedString("weekday.sunday.short", comment: "Short name for Sunday")
        }
    }

    var fullName: String {
        switch self {
        case .monday: NSLocalizedString("weekday.monday", comment: "Full name for Monday")
        case .tuesday: NSLocalizedString("weekday.tuesday", comment: "Full name for Tuesday")
        case .wednesday: NSLocalizedString("weekday.wednesday", comment: "Full name for Wednesday")
        case .thursday: NSLocalizedString("weekday.thursday", comment: "Full name for Thursday")
        case .friday: NSLocalizedString("weekday.friday", comment: "Full name for Friday")
        case .saturday: NSLocalizedString("weekday.saturday", comment: "Full name for Saturday")
        case .sunday: NSLocalizedString("weekday.sunday", comment: "Full name for Sunday")
        }
    }
}
