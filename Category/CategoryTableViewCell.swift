//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Ekaterina on 10.09.2026.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {

    // MARK: - Constants

    static let reuseIdentifier = "CategoryTableViewCell"

    private enum Constants {
        static let cornerRadius: CGFloat = 11
        static let sideInset: CGFloat = 16
    }

    // MARK: - Private Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Methods

    func configure(with viewModel: CategoryCellModel) {
        titleLabel.text = viewModel.title
        accessoryType = viewModel.isSelected ? .checkmark : .none
        tintColor = UIColor(resource: .ypBlue)
    }

    // MARK: - Private Methods

    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.layer.cornerRadius = Constants.cornerRadius
        backgroundColor = UIColor(resource: .background)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.sideInset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.sideInset),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
