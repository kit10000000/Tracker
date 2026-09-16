//
//  TrackersPresenterStub.swift
//  TrackerTests
//
//  Created by Ekaterina on 15.09.2026.
//

import UIKit
@testable import Tracker

final class TrackersPresenterStub: TrackersPresenterProtocol {

    // MARK: - Properties

    var view: (any TrackersViewControllerProtocol)?
    var currentFilter: TrackerFilter
    var categoriesCount: Int {
        categories.count
    }

    var trackersCount: Int {
        categories.map { $0.trackers.count }.reduce(0, +)
    }

    // MARK: - Private Properties

    private var categories: [TrackerCategory]

    // MARK: - Initializers

    init(categories: [TrackerCategory] = MockData.categories) {
        self.categories = categories
        self.currentFilter = .all
    }

    // MARK: - Methods

    func viewDidLoad() {
        view?.showTrackers()
        view?.reloadTrackers()
    }

    func numberOfTrackers(in section: Int) -> Int {
        categories[section].trackers.count
    }

    func categoryTitle(at index: Int) -> String {
        categories[index].title
    }

    func tracker(at section: Int, _ index: Int) -> TrackerViewModel {
        let tracker = categories[section].trackers[index]
        return TrackerViewModel(
            title: tracker.title,
            color: UIColor(named: tracker.color) ?? .systemGreen,
            emoji: tracker.emoji,
            isCompleted: false,
            isCompletionAllowed: true,
            count: 0
        )
    }

    func trackerForEditing(at section: Int, _ index: Int) -> (tracker: Tracker, category: String, days: Int) {
        return (Tracker(id: UUID(), title: "", color: "", emoji: "", schedule: []), "", 0)
    }

    func didSelectDate(_ date: Date) {}

    func didChangeSearchText(_ query: String) {}

    func didTapComplete(at section: Int, _ index: Int) {}

    func didTapDelete(at section: Int, _ index: Int) {}

    func didSelectFilter(_ filter: TrackerFilter) {}

}
