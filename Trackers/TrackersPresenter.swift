//
//  TrackerPresenter.swift
//  Tracker
//
//  Created by Ekaterina on 05.08.2026.
//

import Foundation

protocol TrackersPresenterProtocol: AnyObject {
    var view: TrackersViewControllerProtocol? { get set }
    var categoriesCount: Int { get }
    var trackersCount: Int { get }
    func viewDidLoad()
    func numberOfTrackers(in row: Int) -> Int
    func categoryTitle(at index: Int) -> String
    func tracker(at section: Int, _ index: Int, on date: Date) -> TrackerViewModel
    func didSelectDate(_ date: Date)
    func didChangeSearchText(_ query: String)
    func didTapComplete(at section: Int, _ index: Int, on date: Date)
}

final class TrackersPresenter: TrackersPresenterProtocol {

    // MARK: - Properties

    weak var view: TrackersViewControllerProtocol?

    var categoriesCount: Int {
       visibleCategories.count
    }

    var trackersCount: Int {
        visibleCategories.map { $0.trackers.count }.reduce(0, +)
    }

    // MARK: - Private Properties

    private var categories: [TrackerCategory] = MockData.categories
    private var completedTrackers: [TrackerRecord] = MockData.completedTrackers
    private var visibleCategories: [TrackerCategory] = []
    private var currentDate = Date()
    private var searchQuery = ""

    // MARK: - Methods

    func viewDidLoad() {
        updateView()
    }

    func numberOfTrackers(in row: Int) -> Int {
        visibleCategories[row].trackers.count
    }

    func categoryTitle(at index: Int) -> String {
        visibleCategories[index].title
    }

    func tracker(at section: Int, _ index: Int, on date: Date) -> TrackerViewModel {
        let tracker = visibleCategories[section].trackers[index]
        let isFuture = Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedDescending
        return TrackerViewModel(
            title: tracker.title,
            color: tracker.color,
            emoji: tracker.emoji,
            isCompleted: completedTrackers.contains(where: { $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: date) }),
            isCompletionAllowed: !isFuture,
            count: completedTrackers.count(where: { $0.trackerId == tracker.id })
        )
    }

    func didTapComplete(at section: Int, _ index: Int, on date: Date) {
        guard Calendar.current.compare(currentDate, to: Date(), toGranularity: .day) != .orderedDescending else { return }
        let tracker = visibleCategories[section].trackers[index]

        if let index = completedTrackers.firstIndex(where: {
            $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: date)
        }) {
            completedTrackers.remove(at: index)
        } else {
            completedTrackers.append(TrackerRecord(trackerId: tracker.id, date: date))
        }
        view?.reloadTrackers()
    }

    func addTracker(_ tracker: Tracker, toCategory categoryTitle: String) {
        var newCategories: [TrackerCategory] = []
        var added = false
        for category in categories {
            if category.title == categoryTitle {
                newCategories.append(TrackerCategory(
                    title: category.title,
                    trackers: category.trackers + [tracker]
                ))
                added = true
            } else {
                newCategories.append(category)
            }
        }
        if !added {
            newCategories.append(TrackerCategory(title: categoryTitle, trackers: [tracker]))
        }
        categories = newCategories
    }

    func didSelectDate(_ date: Date) {
        currentDate = date
        updateView()
    }

    func didChangeSearchText(_ query: String) {
        searchQuery = query
        updateView()
    }

    // MARK: - Private Methods

    private func updateView() {
        filterVisibleCategories()
        if trackersCount == 0 {
            view?.showWelcomeScreen()
        } else {
            view?.showTrackers()
            view?.reloadTrackers()
        }
    }

    private func filterVisibleCategories() {
        visibleCategories = []
        let systemWeekday = Calendar.current.component(.weekday, from: currentDate)
        guard let weekDay = WeekDay(rawValue: systemWeekday == 1 ? 7 : systemWeekday - 1) else { return }
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
