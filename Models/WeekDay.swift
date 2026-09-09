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
        case .monday: "Пн"
        case .tuesday: "Вт"
        case .wednesday: "Ср"
        case .thursday: "Чт"
        case .friday: "Пт"
        case .saturday: "Сб"
        case .sunday: "Вс"
        }
    }

    var fullName: String {
        switch self {
        case .monday: "Понедельник"
        case .tuesday: "Вторник"
        case .wednesday: "Среда"
        case .thursday: "Четверг"
        case .friday: "Пятница"
        case .saturday: "Суббота"
        case .sunday: "Воскресенье"
        }
    }
}
