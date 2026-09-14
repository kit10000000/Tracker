//
//  OnboardingStorage.swift
//  Tracker
//
//  Created by Ekaterina on 09.09.2026.
//

import Foundation

final class OnboardingStorage {

    private let storage = UserDefaults.standard
    private let hasSeenOnboardingKey = "hasSeenOnboarding"

    var hasSeenOnboarding: Bool {
        get { storage.bool(forKey: hasSeenOnboardingKey) }
        set { storage.set(newValue, forKey: hasSeenOnboardingKey) }
    }
}
