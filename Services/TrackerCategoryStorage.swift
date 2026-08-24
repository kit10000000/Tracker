//
//  TrackerCategoryStorage.swift
//  Tracker
//
//  Created by Ekaterina on 21.08.2026.
//

import Foundation

final class TrackerCategoryStorage {

    // MARK: - Properties

    static let shared = TrackerCategoryStorage()
    private(set) var categories: [TrackerCategory] = []

    // MARK: - Initializers

    private init() {}

    // MARK: - Methods

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
}
