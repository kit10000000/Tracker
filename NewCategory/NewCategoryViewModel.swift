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
    var onCategoryUpdated: Binding<String>?
    var onError: Binding<String>?

    var initialTitle: String { editingTitle ?? "" }
    var isEditing: Bool { editingTitle != nil }

    // MARK: - Private Properties

    private var currentTitle: String
    private var editingTitle: String?
    private let store: TrackerCategoryStore

    // MARK: - Initializers

    init(store: TrackerCategoryStore = TrackerCategoryStore(), editingTitle: String? = nil) {
        self.store = store
        self.currentTitle = editingTitle ?? ""
        self.editingTitle = editingTitle
    }

    // MARK: - Methods

    func didChangeText(_ text: String) {
        currentTitle = text.trimmingCharacters(in: .whitespaces)
        onReadyStateChange?(!currentTitle.isEmpty)
    }

    func didTapDone() {
        let normalized = currentTitle.lowercased()
        let isDuplicate = store.titles().contains {
            $0.lowercased() == normalized && $0.lowercased() != editingTitle?.lowercased()
        }

        if isDuplicate {
            onError?(NSLocalizedString("newCategory.error.duplicate", comment: "Duplicate category name error"))
            return
        }
        if self.editingTitle != nil {
            onCategoryUpdated?(currentTitle)
        } else {
            onCategoryCreated?(currentTitle)
        }
    }
}
