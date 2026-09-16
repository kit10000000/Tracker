//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Ekaterina on 02.08.2026.
//

import UIKit

final class StatisticsViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let sideInset: CGFloat = 16
        static let titleTopOffset: CGFloat = 6
        static let cardTopSpacing: CGFloat = 77
        static let placeholderSize: CGFloat = 80
        static let placeholderTextSpacing: CGFloat = 8
    }

    // MARK: - Private Properties

    private var viewModel: StatisticsViewModel?

    private lazy var titleTextLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statistics.title", comment: "Statistics screen title")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cardView = StatisticsCardView()

    private lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .empty)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var emptyTextLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statistics.placeholder.empty", comment: "Empty statistics placeholder")
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.load()
    }

    // MARK: - Methods

    func initialize(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        bind()
    }

    // MARK: - Private Methods

    private func bind() {
        guard let viewModel else { return }

        viewModel.onChange = { [weak self] in
            guard let self, let viewModel = self.viewModel else { return }
            self.cardView.configure(
                count: viewModel.completedCount,
                title: NSLocalizedString("statistics.completed", comment: "")
            )
            self.cardView.isHidden = viewModel.isEmpty
            self.emptyImageView.isHidden = !viewModel.isEmpty
            self.emptyTextLabel.isHidden = !viewModel.isEmpty
        }
    }

    private func setupUI() {
        view.backgroundColor = UIColor(resource: .ypWhite)

        view.addSubview(titleTextLabel)
        view.addSubview(cardView)
        view.addSubview(emptyImageView)
        view.addSubview(emptyTextLabel)

        NSLayoutConstraint.activate([
            titleTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTopOffset),
            titleTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),

            cardView.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: Constants.cardTopSpacing),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideInset),

            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: Constants.placeholderSize),
            emptyImageView.heightAnchor.constraint(equalToConstant: Constants.placeholderSize),

            emptyTextLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: Constants.placeholderTextSpacing),
            emptyTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),
            emptyTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideInset)
        ])
    }
}
