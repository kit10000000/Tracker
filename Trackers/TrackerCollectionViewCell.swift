//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Ekaterina on 06.08.2026.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {

    // MARK: - Constants

    static let reuseIdentifier = "TrackerCollectionViewCell"

    private enum Constants {
        static let cardHeight: CGFloat = 90
        static let cardCornerRadius: CGFloat = 16
        static let emojiBackgroundSize: CGFloat = 24
        static let emojiBackgroundCornerRadius: CGFloat = 12
        static let emojiBackgroundAlpha: CGFloat = 0.3
        static let buttonSize: CGFloat = 34
        static let buttonCornerRadius: CGFloat = 17
        static let buttonTopPadding: CGFloat = 8
        static let completedAlpha: CGFloat = 0.3
        static let padding: CGFloat = 12
    }

    // MARK: - Properties

    var onCompleteTapped: (() -> Void)?

    // MARK: - Private Properties

    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cardCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var emojiBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(Constants.emojiBackgroundAlpha)
        view.layer.cornerRadius = Constants.emojiBackgroundCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.tintColor = .white
        button.addAction(UIAction { [weak self] _ in
            self?.onCompleteTapped?()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(with tracker: TrackerViewModel) {
        let color = UIColor(named: tracker.color) ?? .systemGreen
        cardView.backgroundColor = color
        completeButton.backgroundColor = color
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.title
        daysLabel.text = daysText(tracker.count)

        let imageName = tracker.isCompleted ? "checkmark" : "plus"
        completeButton.setImage(UIImage(systemName: imageName), for: .normal)
        completeButton.alpha = tracker.isCompleted ? Constants.completedAlpha : 1.0
    }

    // MARK: - Private Methods

    private func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubview(emojiBackgroundView)
        emojiBackgroundView.addSubview(emojiLabel)
        cardView.addSubview(titleLabel)
        contentView.addSubview(daysLabel)
        contentView.addSubview(completeButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: Constants.cardHeight),

            emojiBackgroundView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Constants.padding),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Constants.padding),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: Constants.emojiBackgroundSize),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: Constants.emojiBackgroundSize),

            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Constants.padding),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -Constants.padding),

            completeButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: Constants.buttonTopPadding),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            completeButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            completeButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize),

            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            daysLabel.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor)
        ])
    }

    private func daysText(_ count: Int) -> String {
        let rem100 = count % 100
        if (11...14).contains(rem100) { return "\(count) дней" }
        switch count % 10 {
        case 1: return "\(count) день"
        case 2...4: return "\(count) дня"
        default: return "\(count) дней"
        }
    }
}
