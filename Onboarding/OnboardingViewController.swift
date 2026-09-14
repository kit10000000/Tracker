//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Ekaterina on 09.09.2026.
//

import UIKit

final class OnboardingViewController: UIPageViewController {

    // MARK: - Constants

    private enum Constants {
        static let buttonSideInset: CGFloat = 20
        static let buttonBottomInset: CGFloat = 50
        static let buttonHeight: CGFloat = 60
        static let pageControlBottomSpacing: CGFloat = 24
    }

    // MARK: - Properties

    var onFinish: (() -> Void)?

    // MARK: - Private Properties

    private lazy var pages: [UIViewController] = {
        let blue = OnboardingPageContentViewController(image: UIImage(resource: .onboarding1), title: NSLocalizedString("onboarding.page1.title", comment: "Onboarding first page title"))
        let red = OnboardingPageContentViewController(image: UIImage(resource: .onboarding2), title: NSLocalizedString("onboarding.page2.title", comment: "Onboarding second page title"))
        return [blue, red]
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .blackDay
        pageControl.pageIndicatorTintColor = .blackDay.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("onboarding.button", comment: "Onboarding finish button"), for: .normal)
        button.setTitleColor(UIColor(resource: .ypWhite), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(resource: .blackDay)
        button.addAction(UIAction { [weak self] _ in
            self?.onFinish?()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initializers

    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setupUI()
    }

    // MARK: - Private Methods

    private func setupUI() {
        setViewControllers([pages[0]], direction: .forward, animated: true)
        view.addSubview(pageControl)
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonSideInset),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonSideInset),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.buttonBottomInset),
            nextButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),

            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -Constants.pageControlBottomSpacing),
        ])
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return nil }
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
