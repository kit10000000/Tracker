//
//  NewCategoryViewModel.swift
//  Tracker
//
//  Created by Ekaterina on 11.09.2026.
//

import Foundation

final class NewCategoryViewModel {

    // MARK: - Properties

    var onReadyStateChange: Binding<Bool>?
    var onCategoryCreated: Binding<String>?
    var onError: Binding<String>?

    // MARK: - Private Properties

    private var currentTitle: String
    private let store: TrackerCategoryStore

    // MARK: - Initializers

    init(store: TrackerCategoryStore = TrackerCategoryStore()) {
        self.store = store
        self.currentTitle = ""
    }

    // MARK: - Methods

    func didChangeText(_ text: String) {
        currentTitle = text.trimmingCharacters(in: .whitespaces)
        onReadyStateChange?(!currentTitle.isEmpty)
    }

    func didTapDone() {
        if store.titles().contains(where: { $0.lowercased() == currentTitle.lowercased() }) {
            onError?("Категория с таким названием уже существует")
            return
        }
        onCategoryCreated?(currentTitle)
    }
}
