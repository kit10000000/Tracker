//
//  CoreDataStack.swift
//  Tracker
//
//  Created by Ekaterina on 04.09.2026.
//

import Foundation
import CoreData

final class CoreDataStack {

    // MARK: - Properties

    static let shared = CoreDataStack()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Private Properties

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerDB")
        container.loadPersistentStores { _, error in
            if let error {
                assertionFailure("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()

    // MARK: - Initializers

    private init() {}
}
