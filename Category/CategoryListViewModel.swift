//
//  CategoryListViewModel.swift
//  Tracker
//
//  Created by Ekaterina on 10.09.2026.
//

import Foundation

typealias Binding<T> = (T) -> Void

final class CategoryListViewModel {

    // MARK: - Properties

    var onCategoriesChange: Binding<[CategoryCellModel]>?
    var onCategorySelect: Binding<String>?

    // MARK: - Private Properties

    private let store: TrackerCategoryStore
    private var selectedCategory: String?

    private var categories: [CategoryCellModel] = [] {
        didSet {
            onCategoriesChange?(categories)
        }
    }

    // MARK: - Initializers

    init(store: TrackerCategoryStore = TrackerCategoryStore(), selectedCategory: String?) {
        self.store = store
        self.selectedCategory = selectedCategory
    }

    // MARK: - Methods

    func loadCategories() {
        categories = store.titles().map { title in
            CategoryCellModel(title: title, isSelected: title == selectedCategory)
        }
    }

    func numberOfRows() -> Int { categories.count }

    func cell(at index: Int) -> CategoryCellModel { categories[index] }

    func didSelectCategory(at index: Int) {
        let title = categories[index].title
        selectedCategory = (selectedCategory == title) ? nil : title
        loadCategories()
        onCategorySelect?(selectedCategory ?? "")
    }

    func addCategory(_ title: String) {
        store.addCategory(title: title)
        loadCategories()
    }
}
