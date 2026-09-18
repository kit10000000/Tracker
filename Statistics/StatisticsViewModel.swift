//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Ekaterina on 16.09.2026.
//

import Foundation

final class StatisticsViewModel {

    // MARK: - Properties

    var onChange: (() -> Void)?
    private(set) var completedCount = 0

    var isEmpty: Bool { completedCount == 0 }

    // MARK: - Private Properties

    private let recordStore: TrackerRecordStore

    // MARK: - Initializers

    init(recordStore: TrackerRecordStore = TrackerRecordStore()) {
        self.recordStore = recordStore
    }

    // MARK: - Methods

    func load() {
        completedCount = recordStore.records().count
        onChange?()
    }
}
