//
//  TrackerOptions.swift
//  Tracker
//
//  Created by Ekaterina on 09.09.2026.
//

import Foundation

enum TrackerOptions {
    static let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
        "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]

    static let colors = (1...18).map { "Color selection \($0)" }
}
