//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Ekaterina on 04.09.2026.
//

import Foundation
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdate()
}

final class TrackerCategoryStore: NSObject {

    // MARK: - Properties

    weak var delegate: TrackerCategoryStoreDelegate?

    // MARK: - Private Properties

    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!

    // MARK: - Initializers

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
        super.init()

        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.title, ascending: false)]

        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try? controller.performFetch()
    }

    // MARK: - Methods

    func categories() -> [TrackerCategory] {
        let trackers = fetchedResultsController.fetchedObjects ?? []
        let grouped = Dictionary(grouping: trackers) { $0.category?.title ?? "" }
        return grouped
            .sorted { $0.key < $1.key }
            .map { title, group in
                let domainTrackers = group
                    .sorted { ($0.title ?? "") < ($1.title ?? "") }
                    .compactMap { try? $0.toDomain() }
                return TrackerCategory(title: title, trackers: domainTrackers)
            }
    }

    func titles() -> [String] {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: false)]
        let result = context.fetchOrEmpty(request)
        return result.compactMap { $0.title }
    }

    func addCategory(title: String) {
        let newCategory = TrackerCategoryCoreData(context: self.context)
        newCategory.title = title
        self.context.saveChanges()
    }

    func categoryCoreData(forTitle: String) -> TrackerCategoryCoreData {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), forTitle)

        if let found = context.fetchOrEmpty(request).first { return found }

        let category = TrackerCategoryCoreData(context: self.context)
        category.title = forTitle
        return category
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
