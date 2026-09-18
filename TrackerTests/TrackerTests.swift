//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Ekaterina on 02.08.2026.
//

import XCTest
@testable import Tracker
import SnapshotTesting

final class TrackerTests: XCTestCase {

    func testTrackersScreenDark() throws {
        let vc = TrackersViewController()
        vc.configure(TrackersPresenterStub())
        assertSnapshot(of: vc, as: .image(on: .iPhone13, traits: .init(userInterfaceStyle: .dark)))
    }

    func testTrackersScreenLight() throws {
        let vc = TrackersViewController()
        vc.configure(TrackersPresenterStub())
        assertSnapshot(of: vc, as: .image(on: .iPhone13, traits: .init(userInterfaceStyle: .light)))
    }
}
