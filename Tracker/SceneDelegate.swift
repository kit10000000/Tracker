//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Ekaterina on 02.08.2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let onboardingStorage = OnboardingStorage()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = makeRootViewController()
        window.makeKeyAndVisible()
        self.window = window
    }

    private func makeRootViewController() -> UIViewController {
        if onboardingStorage.hasSeenOnboarding {
            return TabBarController()
        }
        let onboarding = OnboardingViewController()
        onboarding.onFinish = { [weak self] in
            self?.onboardingStorage.hasSeenOnboarding = true
            self?.switchToMainApp()
        }
        return onboarding
    }

    private func switchToMainApp() {
        guard let window else { return }
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.rootViewController = TabBarController()
        }
    }
}
