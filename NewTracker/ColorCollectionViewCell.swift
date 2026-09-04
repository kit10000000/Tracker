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

    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? 3 : 0
            contentView.layer.borderColor = isSelected
                ? colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
                : UIColor.clear.cgColor
        }
    }

    // MARK: - Private Properties

    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
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
        contentView.layer.cornerRadius = 11
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
    }
}
