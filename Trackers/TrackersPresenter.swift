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
}

final class TrackersPresenter: TrackersPresenterProtocol {

    // MARK: - Properties

    weak var view: TrackersViewControllerProtocol?

    var categoriesCount: Int {
       categories.count
    }

    var trackersCount: Int {
        categories.map { $0.trackers.count }.reduce(0, +)
    }

    // MARK: - Private Properties

    private var categories: [TrackerCategory] = MockData.categories
    private var completedTrackers: [TrackerRecord] = MockData.completedTrackers

    // MARK: - Methods

    func viewDidLoad() {
        if trackersCount == 0 {
            view?.showWelcomeScreen()
        } else {
            view?.showTrackers()
        }
    }

    func numberOfTrackers(in row: Int) -> Int {
        categories[row].trackers.count
    }

    func didTapComplete(trackerUUID: UUID, on date: Date) {
        if let index = completedTrackers.firstIndex(where: {
            $0.trackerId == trackerUUID && Calendar.current.isDate($0.date, inSameDayAs: date)
        }) {
            completedTrackers.remove(at: index)
        } else {
            completedTrackers.append(TrackerRecord(trackerId: trackerUUID, date: date))
        }
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

    func categoryTitle(at index: Int) -> String {
        categories[index].title
    }

    func tracker(at section: Int, _ index: Int, on date: Date) -> TrackerViewModel {
        let tracker = categories[section].trackers[index]
        return TrackerViewModel(
            title: tracker.title,
            color: tracker.color,
            emoji: tracker.emoji,
            isCompleted: completedTrackers.contains(where: { $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: date) }),
            count: completedTrackers.count(where: { $0.trackerId == tracker.id })
        )
    }
}
