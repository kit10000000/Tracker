//
//  Analytics.swift
//  Tracker
//
//  Created by Ekaterina on 16.09.2026.
//

import Foundation
import AppMetricaCore

enum AnalyticsEvent: String {
    case open, close, click
}

enum AnalyticsItem: String {
    case addTrack = "add_track"
    case track, filter, edit, delete
}

final class Analytics {
    func report(_ event: AnalyticsEvent, item: AnalyticsItem? = nil) {
        var params: [AnyHashable: Any] = ["screen": "Main"]
        if let item { params["item"] = item.rawValue }
        #if DEBUG
        print("Analytics event: \(event.rawValue), params: \(params)")
        #endif
        AppMetrica.reportEvent(name: event.rawValue, parameters: params) { error in
            print("Analytics error: \(error)")
        }
    }
}
