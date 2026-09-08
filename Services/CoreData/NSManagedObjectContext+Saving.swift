//
//  NSManagedObjectContext+Saving.swift
//  Tracker
//
//  Created by Ekaterina on 08.09.2026.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func saveChanges() {
        guard hasChanges else { return }
        do {
            try save()
        } catch {
            assertionFailure("CoreData save failed: \(error)")
        }
    }

    func fetchOrEmpty<T>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            return try fetch(request)
        } catch {
            assertionFailure("fetch failed: \(error)")
            return []
        }
    }
}
