//
//  FilterStorage.swift
//  Tracker
//
//  Created by Ekaterina on 16.09.2026.
//

import Foundation

final class FilterStorage {
    private let storage = UserDefaults.standard
    private let selectedFilterKey = "selectedFilter"

    var filter: TrackerFilter {
        get { TrackerFilter(rawValue: storage.integer(forKey: selectedFilterKey)) ?? .all }
        set { storage.set(newValue.rawValue, forKey: selectedFilterKey) }
    }
}
