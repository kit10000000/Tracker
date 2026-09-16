//
//  TrackerPresenter.swift
//  Tracker
//
//  Created by Ekaterina on 05.08.2026.
//

import UIKit

protocol TrackersPresenterProtocol: AnyObject {
    var view: TrackersViewControllerProtocol? { get set }
    var categoriesCount: Int { get }
    var trackersCount: Int { get }
    func viewDidLoad()
    func numberOfTrackers(in section: Int) -> Int
    func categoryTitle(at index: Int) -> String
    func tracker(at section: Int, _ index: Int) -> TrackerViewModel
    func didSelectDate(_ date: Date)
    func didChangeSearchText(_ query: String)
    func didTapComplete(at section: Int, _ index: Int)
    func didTapDelete(at section: Int, _ index: Int)
    func trackerForEditing(at section: Int, _ index: Int) -> (tracker: Tracker, category: String, days: Int)
}

final class TrackersPresenter: TrackersPresenterProtocol, TrackerCategoryStoreDelegate {

    // MARK: - Properties

    weak var view: TrackersViewControllerProtocol?

    var categoriesCount: Int {
        visibleCategories.count
    }

    var trackersCount: Int {
        visibleCategories.map { $0.trackers.count }.reduce(0, +)
    }

    // MARK: - Private Properties

    private var categories: [TrackerCategory] { categoryStore.categories() }
    private var completedTrackers: [TrackerRecord] { recordStore.records() }
    private var visibleCategories: [TrackerCategory] = []
    private var completedIds: Set<UUID> = []
    private var currentDate = Date()
    private var searchQuery = ""
    private let categoryStore: TrackerCategoryStore
    private let recordStore: TrackerRecordStore
    private let trackerStore: TrackerStore

    private var isFutureDate: Bool {
        Calendar.current.compare(currentDate, to: Date(), toGranularity: .day) == .orderedDescending
    }

    // MARK: - Initializers

    init(categoryStore: TrackerCategoryStore = TrackerCategoryStore(),
         recordStore: TrackerRecordStore = TrackerRecordStore(), trackerStore: TrackerStore = TrackerStore()) {
        self.categoryStore = categoryStore
        self.recordStore = recordStore
        self.trackerStore = trackerStore
    }

    // MARK: - Methods

    func viewDidLoad() {
        updateView()
        self.categoryStore.delegate = self
    }

    func didUpdate() {
        updateView()
    }

    func numberOfTrackers(in section: Int) -> Int {
        visibleCategories[section].trackers.count
    }

    func categoryTitle(at index: Int) -> String {
        visibleCategories[index].title
    }

    func tracker(at section: Int, _ index: Int) -> TrackerViewModel {
        let tracker = visibleCategories[section].trackers[index]
        let color = UIColor(named: tracker.color)
        assert(color != nil, "неизвестный ассет цвета: \(tracker.color)")
        return TrackerViewModel(
            title: tracker.title,
            color: color ?? .systemGreen,
            emoji: tracker.emoji,
            isCompleted: completedIds.contains(tracker.id),
            isCompletionAllowed: !isFutureDate,
            count: completedTrackers.count(where: { $0.trackerId == tracker.id })
        )
    }

    func didTapComplete(at section: Int, _ index: Int) {
        guard !isFutureDate else { return }
        let tracker = visibleCategories[section].trackers[index]
        recordStore.toggleRecord(for: tracker.id, on: currentDate)
        updateCompletedIds()
        view?.reloadTrackers()
    }

    func didTapDelete(at section: Int, _ index: Int) {
        let tracker = visibleCategories[section].trackers[index]

        do {
            try trackerStore.deleteTracker(tracker.id)
        } catch TrackerStoreError.trackerDoesntExist {
            view?.showErrorAlert(NSLocalizedString("tracker.error.absent", comment: "Tracker doesn't exist error"))
        } catch {}
    }

    func didSelectDate(_ date: Date) {
        currentDate = date
        updateView()
    }

    func didChangeSearchText(_ query: String) {
        searchQuery = query
        updateView()
    }

    func trackerForEditing(at section: Int, _ index: Int) -> (tracker: Tracker, category: String, days: Int) {
        let tracker = visibleCategories[section].trackers[index]
        let category = visibleCategories[section].title
        let days = completedTrackers.count(where: { $0.trackerId == tracker.id })
        return (tracker, category, days)
    }

    // MARK: - Private Methods

    private func updateView() {
        filterVisibleCategories()
        updateCompletedIds()
        if trackersCount == 0 {
            if searchQuery.isEmpty {
                view?.showWelcomeScreen()
            } else {
                view?.showSearchErrorScreen()
            }
        } else {
            view?.showTrackers()
            view?.reloadTrackers()
        }
    }

    private func updateCompletedIds() {
        completedIds = Set(
            completedTrackers
                .filter { Calendar.current.isDate($0.date, inSameDayAs: currentDate) }
                .map { $0.trackerId }
        )
    }

    private func filterVisibleCategories() {
        visibleCategories = []
        guard let weekDay = WeekDay(date: currentDate) else { return }
        for category in categories {
            let scheduled = category.trackers.filter { tracker in
                tracker.schedule.contains(weekDay) &&
                (searchQuery.isEmpty || tracker.title.localizedCaseInsensitiveContains(searchQuery))
            }
            if !scheduled.isEmpty {
                visibleCategories.append(TrackerCategory(title: category.title, trackers: scheduled))
            }
        }
    }
}
