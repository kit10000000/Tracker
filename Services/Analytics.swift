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

enum AnalyticsScreen: String {
    case main = "Main"
    case statistics = "Statistics"
}

final class Analytics {
    func report(_ event: AnalyticsEvent, screen: AnalyticsScreen, item: AnalyticsItem? = nil) {
        var params: [AnyHashable: Any] = [
            "screen": screen.rawValue
        ]
        if let item { params["item"] = item.rawValue }
        #if DEBUG
        print("Analytics event: \(event.rawValue), params: \(params)")
        #endif
        AppMetrica.reportEvent(name: event.rawValue, parameters: params) { error in
            print("Analytics error: \(error)")
        }
    }
}
