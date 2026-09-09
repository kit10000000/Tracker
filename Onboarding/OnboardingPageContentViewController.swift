//
//  OnboardingPageContentViewController.swift
//  Tracker
//
//  Created by Ekaterina on 09.09.2026.
//

import UIKit

final class OnboardingPageContentViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let titleFontSize: CGFloat = 32
        static let labelSideInset: CGFloat = 16
        static let labelCenterYOffset: CGFloat = 50
    }

    // MARK: - Private Properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    private var titleText: String
    private var onboardingImage: UIImage

    // MARK: - Initializers

    init(image: UIImage, title: String) {
        onboardingImage = image
        titleText = title
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = self.onboardingImage
        textLabel.text = self.titleText
        setupUI()
    }

    // MARK: - Private Methods

    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(textLabel)

        textLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.labelSideInset),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.labelSideInset),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Constants.labelCenterYOffset),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
