//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Ekaterina on 04.09.2026.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {

    // MARK: - Constants

    static let reuseIdentifier = "ColorCollectionViewCell"

    private enum Constants {
        static let selectedBorderWidth: CGFloat = 3
        static let selectedBorderAlpha: CGFloat = 0.3
        static let cornerRadius: CGFloat = 11
        static let colorViewCornerRadius: CGFloat = 8
        static let colorViewVerticalInset: CGFloat = 6
        static let colorViewHorizontalInset: CGFloat = 7
    }

    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? Constants.selectedBorderWidth : 0
            contentView.layer.borderColor = isSelected
                ? colorView.backgroundColor?.withAlphaComponent(Constants.selectedBorderAlpha).cgColor
                : UIColor.clear.cgColor
        }
    }

    // MARK: - Private Properties

    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.colorViewCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

    func configure(with colorName: String) {
        colorView.backgroundColor = UIColor(named: colorName)
    }

    // MARK: - Private Methods

    private func setupUI() {
        contentView.addSubview(colorView)
        contentView.layer.cornerRadius = Constants.cornerRadius
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.colorViewVerticalInset),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.colorViewHorizontalInset),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.colorViewHorizontalInset),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.colorViewVerticalInset),
        ])
    }
}
