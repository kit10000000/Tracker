//
//  TabBarController.swift
//  Tracker
//
//  Created by Ekaterina on 02.08.2026.
//

import UIKit

final class TabBarController: UITabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let trackersViewController = TrackersViewController()
        let trackersPresenter = TrackersPresenter()
        trackersViewController.configure(trackersPresenter)

        let trackersVC = UINavigationController(rootViewController: trackersViewController)
        trackersVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(resource: .trackersTab),
            selectedImage: nil
        )

        let statisticsVC = UINavigationController(rootViewController: StatisticsViewController())
        statisticsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .statisticsTab),
            selectedImage: nil
        )

        viewControllers = [trackersVC, statisticsVC]
    }
}
