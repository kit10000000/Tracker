//
//  AppDelegate.swift
//  Tracker
//
//  Created by Ekaterina on 02.08.2026.
//

import UIKit
import AppMetricaCore

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DaysValueTransformer.register()

        // Override point for customization after application launch.
        if let configuration = AppMetricaConfiguration(apiKey: "111cc107-4686-4aff-9c97-dad01c57b6f8") {
            AppMetrica.activate(with: configuration)
        }
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}
