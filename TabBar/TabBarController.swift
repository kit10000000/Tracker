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
            title: NSLocalizedString("trackers.title", comment: "Trackers tab bar title"),
            image: UIImage(resource: .trackersTab),
            selectedImage: nil
        )
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.initialize(viewModel: StatisticsViewModel())

        let statisticsVC = UINavigationController(rootViewController: statisticsViewController)
        statisticsVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statistics.title", comment: "Statistics tab bar title"),
            image: UIImage(resource: .statisticsTab),
            selectedImage: nil
        )

        viewControllers = [trackersVC, statisticsVC]
    }
}
