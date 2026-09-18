//
//  StatisticsCardView.swift
//  Tracker
//
//  Created by Ekaterina on 16.09.2026.
//

import UIKit

final class StatisticsCardView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 1
        static let padding: CGFloat = 12
        static let labelSpacing: CGFloat = 7
    }

    // MARK: - Private Properties

    private let gradientLayer = CAGradientLayer()
    private let borderShape = CAShapeLayer()

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupGradientBorder()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        borderShape.path = UIBezierPath(
            roundedRect: bounds.insetBy(dx: Constants.borderWidth / 2, dy: Constants.borderWidth / 2),
            cornerRadius: Constants.cornerRadius
        ).cgPath
    }

    // MARK: - Methods

    func configure(count: Int, title: String) {
        countLabel.text = String(count)
        titleLabel.text = title
    }

    // MARK: - Private Methods

    private func setupGradientBorder() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [
            UIColor(red: 0.99, green: 0.30, blue: 0.29, alpha: 1),
            UIColor(red: 0.27, green: 0.90, blue: 0.62, alpha: 1),
            UIColor(red: 0.00, green: 0.48, blue: 0.98, alpha: 1)
        ].map { $0.cgColor }

        borderShape.lineWidth = Constants.borderWidth
        borderShape.fillColor = UIColor.clear.cgColor
        borderShape.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = borderShape

        layer.addSublayer(gradientLayer)
    }

    private func setupLayout() {
        addSubview(countLabel)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.padding),
            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),

            titleLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: Constants.labelSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.padding)
        ])
    }
}
