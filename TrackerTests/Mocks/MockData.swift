//
//  MockData.swift
//  Tracker
//
//  Created by Ekaterina on 06.08.2026.
//

import Foundation
import UIKit

enum MockData {

    // MARK: - Tracker IDs

    private static let waterPlantsId = UUID()
    private static let cookDinnerId = UUID()
    private static let cleaningId = UUID()
    private static let catOnCallId = UUID()
    private static let grandmaPostcardId = UUID()
    private static let aprilDatesId = UUID()
    private static let goodMoodId = UUID()
    private static let workoutId = UUID()
    private static let drinkWaterId = UUID()
    private static let earlySleepId = UUID()

    // MARK: - Categories

    static let categories: [TrackerCategory] = [
        TrackerCategory(
            title: "Домашний уют",
            trackers: [
                Tracker(
                    id: waterPlantsId,
                    title: "Поливать растения",
                    color: "Color selection 5",
                    emoji: "❤️",
                    schedule: [.monday, .wednesday, .friday]
                ),
                Tracker(
                    id: cookDinnerId,
                    title: "Приготовить ужин",
                    color: "Color selection 2",
                    emoji: "🥦",
                    schedule: WeekDay.allCases
                ),
                Tracker(
                    id: cleaningId,
                    title: "Уборка в квартире",
                    color: "Color selection 14",
                    emoji: "🧹",
                    schedule: [.saturday]
                )
            ]
        ),
        TrackerCategory(
            title: "Радостные мелочи",
            trackers: [
                Tracker(
                    id: catOnCallId,
                    title: "Кошка заслонила камеру на созвоне",
                    color: "Color selection 11",
                    emoji: "😻",
                    schedule: WeekDay.allCases
                ),
                Tracker(
                    id: grandmaPostcardId,
                    title: "Бабушка прислала открытку в вотсапе",
                    color: "Color selection 7",
                    emoji: "🌺",
                    schedule: [.sunday]
                ),
                Tracker(
                    id: aprilDatesId,
                    title: "Свидания в апреле",
                    color: "Color selection 1",
                    emoji: "❤️",
                    schedule: [.friday, .saturday]
                ),
                Tracker(
                    id: goodMoodId,
                    title: "Хорошее настроение",
                    color: "Color selection 16",
                    emoji: "🙂",
                    schedule: WeekDay.allCases
                )
            ]
        ),
        TrackerCategory(
            title: "Самочувствие",
            trackers: [
                Tracker(
                    id: workoutId,
                    title: "Тренировка",
                    color: "Color selection 10",
                    emoji: "🏓",
                    schedule: [.tuesday, .thursday, .saturday]
                ),
                Tracker(
                    id: drinkWaterId,
                    title: "Пить воду",
                    color: "Color selection 8",
                    emoji: "💧",
                    schedule: WeekDay.allCases
                ),
                Tracker(
                    id: earlySleepId,
                    title: "Лечь спать до 23:00",
                    color: "Color selection 15",
                    emoji: "😪",
                    schedule: WeekDay.allCases
                )
            ]
        )
    ]

    // MARK: - Completed Trackers

    static let completedTrackers: [TrackerRecord] = [
        TrackerRecord(trackerId: cookDinnerId, date: Date()),
        TrackerRecord(trackerId: drinkWaterId, date: Date()),
        TrackerRecord(trackerId: goodMoodId, date: Date())
    ]
}
