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
    var emojisCount: Int { get }
    var colorsCount: Int { get }
    var emojiSectionTitle: String { get }
    var colorSectionTitle: String { get }
    func emoji(at index: Int) -> String
    func colorName(at index: Int) -> String
    func didChangeName(_ name: String)
    func subtitle(for row: Int) -> String?
    func didSelectSchedule(_ schedule: [WeekDay])
    func didSelectColor(at index: Int)
    func didSelectEmoji(at index: Int)
    func didTapCreate()
    
}

final class NewTrackerPresenter: NewTrackerPresenterProtocol {

    // MARK: - Properties

    weak var view: NewTrackerViewControllerProtocol?

    var currentSchedule: [WeekDay] { schedule }

    var emojisCount: Int {
        emojis.count
    }

    var colorsCount: Int {
        colors.count
    }
    var emojiSectionTitle: String { emojiTitle }
    var colorSectionTitle: String { colorTitle }
    // MARK: - Private Properties

    private var name = ""
    private var schedule: [WeekDay] = []
    private var selectedCategory = "Важное"
    private var selectedEmoji = ""
    private var selectedColor = ""
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
        "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]

    private let colors = (1...18).map { "Color selection \($0)" }
    private let emojiTitle = "Emoji"
    private let colorTitle = "Цвет"


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

    func didSelectColor(at index: Int) {
        selectedColor = colors[index]
        view?.setCreateButtonEnabled(validateNewTrackerForm())
    }

    func didSelectEmoji(at index: Int) {
        selectedEmoji = emojis[index]
        view?.setCreateButtonEnabled(validateNewTrackerForm())
    }

    func emoji(at index: Int) -> String {
        emojis[index]
    }

    func colorName(at index: Int) -> String {
        colors[index]
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

        let newTracker = Tracker(id: UUID(), title: self.name, color: selectedColor, emoji: selectedEmoji, schedule: self.schedule)
        TrackerCategoryStorage.shared.addTracker(newTracker, toCategory: self.selectedCategory)
    }

    // MARK: - Private Methods

    private func validateNewTrackerForm() -> Bool {
        !name.isEmpty && !schedule.isEmpty && !selectedCategory.isEmpty && !selectedColor.isEmpty && !selectedEmoji.isEmpty
    }
}
