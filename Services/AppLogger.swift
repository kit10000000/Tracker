//
//  AppLogger.swift
//  Tracker
//
//  Created by Ekaterina on 18.09.2026.
//

import OSLog

enum AppLogger {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Tracker",
        category: "App"
    )

    static func error(_ message: String) {
        logger.error("\(message, privacy: .public)")
    }
}
