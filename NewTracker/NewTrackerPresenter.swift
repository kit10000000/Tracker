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
    var currentCategory: String { get }
    var selectedEmojiIndex: Int? { get }
    var selectedColorIndex: Int? { get }
    var currentName: String { get }
    var isEditing: Bool { get }
    var screenTitle: String { get }
    var buttonTitle: String { get }
    var isFormValid: Bool { get }
    var completedDaysText: String { get }
    func didSelectCategory(_ title: String)
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

    var currentSchedule: [WeekDay] { trackerDraft.schedule }

    var emojisCount: Int {
        TrackerOptions.emojis.count
    }

    var colorsCount: Int {
        TrackerOptions.colors.count
    }

    var emojiSectionTitle: String { emojiTitle }
    var colorSectionTitle: String { colorTitle }
    var currentCategory: String { trackerDraft.category }
    var currentName: String { trackerDraft.name }
    var selectedEmojiIndex: Int? {
        trackerDraft.emoji.flatMap { TrackerOptions.emojis.firstIndex(of: $0) }
    }
    var selectedColorIndex: Int? {
        trackerDraft.color.flatMap { TrackerOptions.colors.firstIndex(of: $0) }
    }
    var isEditing: Bool { trackerDraft.id != nil }
    var screenTitle: String {
        trackerDraft.id != nil
            ? NSLocalizedString("editTracker.title", comment: "Edit habit screen title")
            : NSLocalizedString("newTracker.title", comment: "New habit screen title")
    }

    var buttonTitle: String {
        trackerDraft.id != nil
            ? NSLocalizedString("common.save", comment: "Edit habit button title")
            : NSLocalizedString("common.create", comment: "New habit button title")
    }

    var isFormValid: Bool {
        trackerDraft.isComplete
    }

    var completedDaysText: String {
        String.localizedStringWithFormat(
            NSLocalizedString("trackers.daysCompleted", comment: "Completed days counter"),
            completedDays
        )
    }

    // MARK: - Private Properties

    private let nameMaxLength = 38
    private let emojiTitle = NSLocalizedString("newTracker.section.emoji", comment: "Emoji section header")
    private let colorTitle = NSLocalizedString("newTracker.section.color", comment: "Color section header")
    private var trackerStore: TrackerStore
    private var trackerDraft: TrackerDraft
    private let completedDays: Int

    // MARK: - Initializers

    init(trackerStore: TrackerStore = TrackerStore(),
         currentTracker: TrackerDraft = TrackerDraft(),
         completedDays: Int = 0) {
        self.trackerStore = trackerStore
        self.trackerDraft = currentTracker
        self.completedDays = completedDays
    }

    // MARK: - Methods

    func didChangeName(_ name: String) {
        self.trackerDraft.name = name.trimmingCharacters(in: .whitespaces)
        view?.setCreateButtonEnabled(validateNewTrackerForm())
    }

    func didSelectSchedule(_ schedule: [WeekDay]) {
        self.trackerDraft.schedule = schedule
        view?.setCreateButtonEnabled(validateNewTrackerForm())
        view?.updateTable(at: 1)
    }

    func didSelectColor(at index: Int) {
        self.trackerDraft.color = TrackerOptions.colors[index]
        view?.setCreateButtonEnabled(validateNewTrackerForm())
    }

    func didSelectEmoji(at index: Int) {
        self.trackerDraft.emoji = TrackerOptions.emojis[index]
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
            return self.trackerDraft.category
        } else {
            guard !self.trackerDraft.schedule.isEmpty else { return nil }
            if self.trackerDraft.schedule.count == WeekDay.allCases.count {
                return NSLocalizedString("newTracker.schedule.everyDay", comment: "Schedule subtitle when every day is selected")
            } else {
                let sorted = self.trackerDraft.schedule.sorted { $0.rawValue < $1.rawValue }
                return sorted.map { $0.shortName }.joined(separator: ", ")
            }
        }
    }

    func isWithinNameLengthLimit(_ text: String) -> Bool {
        text.count <= nameMaxLength
    }

    func didTapCreate() {
        guard let emoji = trackerDraft.emoji,
              let color = trackerDraft.color
        else { return }

        if let id = trackerDraft.id {
            do {
                let tracker = Tracker(id: id, title: trackerDraft.name, color: color, emoji: emoji, schedule: trackerDraft.schedule)
                try trackerStore.updateTracker(tracker, toCategory: trackerDraft.category)
            } catch StoreError.entityDoesntExist {
                view?.showErrorAlert(NSLocalizedString("tracker.error.absent", comment: "Tracker doesn't exist error"))
            } catch {}
        } else {
            let tracker = Tracker(id: UUID(), title: trackerDraft.name, color: color, emoji: emoji, schedule: trackerDraft.schedule)
            trackerStore.addTracker(tracker, toCategory: trackerDraft.category)
        }

        view?.dismissForm()
    }

    func didSelectCategory(_ title: String) {
        self.trackerDraft.category = title
        view?.setCreateButtonEnabled(validateNewTrackerForm())
        view?.updateTable(at: 0)
    }

    // MARK: - Private Methods

    private func validateNewTrackerForm() -> Bool {
        self.trackerDraft.isComplete
    }
}
