//
//  TrackerSectionHeaderView.swift
//  Tracker
//
//  Created by Ekaterina on 17.08.2026.
//

import UIKit

final class TrackerSectionHeaderView: UICollectionReusableView {

    // MARK: - Constants

    static let reuseIdentifier = "header"

    private enum Constants {
        static let leadingPadding: CGFloat = 28
        static let trailingPadding: CGFloat = -16
        static let bottomPadding: CGFloat = -12
    }

    // MARK: - Private Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingPadding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: Constants.trailingPadding),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.bottomPadding)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(title: String) {
        titleLabel.text = title
    }
}
