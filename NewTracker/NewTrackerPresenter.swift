//
//  NewTrackerPresenter.swift
//  Tracker
//
//  Created by Ekaterina on 18.08.2026.
//

import Foundation

protocol NewTrackerPresenterProtocol: AnyObject {
    var view: NewTrackerViewControllerProtocol? { get set }
    var currentSchedule: [WeekDay] { get }
    func didChangeName(_ name: String)
    func subtitle(for row: Int) -> String?
    func didSelectSchedule(_ schedule: [WeekDay])
    func didTapCreate()
}

final class NewTrackerPresenter: NewTrackerPresenterProtocol {

    // MARK: - Properties

    weak var view: NewTrackerViewControllerProtocol?

    var currentSchedule: [WeekDay] { schedule }

    // MARK: - Private Properties

    private var name = ""
    private var schedule: [WeekDay] = []
    private var selectedCategory = "Важное"
    private static let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
        "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]

    // MARK: - Methods

    func didChangeName(_ name: String) {
        self.name = name.trimmingCharacters(in: .whitespaces)
        view?.setCreateButtonEnabled(validateNewTrackerForm())
    }

    func didSelectSchedule(_ schedule: [WeekDay]) {
        self.schedule = schedule
        view?.setCreateButtonEnabled(validateNewTrackerForm())
        view?.updateTable(at: 1)
    }

    func subtitle(for row: Int) -> String? {
        if row == 0 {
            return selectedCategory
        } else {
            guard !schedule.isEmpty else { return nil }
            if schedule.count == WeekDay.allCases.count {
                return "Каждый день"
            } else {
                let sorted = schedule.sorted { $0.rawValue < $1.rawValue }
                return sorted.map { $0.shortName }.joined(separator: ", ")
            }
        }
    }

    func didTapCreate() {
        if !validateNewTrackerForm() { return }
        let color = "Color selection \(Int.random(in: 1...18))"
        let emoji = Self.emojis.randomElement() ?? "🙂"

        let newTracker = Tracker(id: UUID(), title: self.name, color: color, emoji: emoji, schedule: self.schedule)
        TrackerCategoryStorage.shared.addTracker(newTracker, toCategory: self.selectedCategory)
    }

    // MARK: - Private Methods

    private func validateNewTrackerForm() -> Bool {
        !name.isEmpty && !schedule.isEmpty && !selectedCategory.isEmpty
    }
}
