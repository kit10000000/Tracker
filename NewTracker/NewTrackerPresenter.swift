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
    func isWithinNameLengthLimit(_ text: String) -> Bool
}

final class NewTrackerPresenter: NewTrackerPresenterProtocol {

    // MARK: - Properties

    weak var view: NewTrackerViewControllerProtocol?

    var currentSchedule: [WeekDay] { schedule }

    var emojisCount: Int {
        TrackerOptions.emojis.count
    }

    var colorsCount: Int {
        TrackerOptions.colors.count
    }

    var emojiSectionTitle: String { emojiTitle }
    var colorSectionTitle: String { colorTitle }

    // MARK: - Private Properties

    private var name = ""
    private let nameMaxLength = 38
    private var schedule: [WeekDay] = []
    private var selectedCategory = "Важное"
    private var selectedEmoji = ""
    private var selectedColor = ""
    private let emojiTitle = "Emoji"
    private let colorTitle = "Цвет"
    private var trackerStore: TrackerStore

    // MARK: - Initializers

    init(trackerStore: TrackerStore = TrackerStore()) {
        self.trackerStore = trackerStore
    }

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
        selectedColor = TrackerOptions.colors[index]
        view?.setCreateButtonEnabled(validateNewTrackerForm())
    }

    func didSelectEmoji(at index: Int) {
        selectedEmoji = TrackerOptions.emojis[index]
        view?.setCreateButtonEnabled(validateNewTrackerForm())
    }

    func emoji(at index: Int) -> String {
        TrackerOptions.emojis[index]
    }

    func colorName(at index: Int) -> String {
        TrackerOptions.colors[index]
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

    func isWithinNameLengthLimit(_ text: String) -> Bool {
        text.count <= nameMaxLength
    }

    func didTapCreate() {
        if !validateNewTrackerForm() { return }

        let newTracker = Tracker(id: UUID(), title: self.name, color: selectedColor, emoji: selectedEmoji, schedule: self.schedule)
        self.trackerStore.addTracker(newTracker, toCategory: self.selectedCategory)
        view?.dismissForm()
    }

    // MARK: - Private Methods

    private func validateNewTrackerForm() -> Bool {
        !name.isEmpty && !schedule.isEmpty && !selectedCategory.isEmpty && !selectedColor.isEmpty && !selectedEmoji.isEmpty
    }
}
