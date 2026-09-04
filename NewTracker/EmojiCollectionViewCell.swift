//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Ekaterina on 03.09.2026.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {

    // MARK: - Constants

    static let reuseIdentifier = "EmojiCollectionViewCell"

    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            emojiBackgroundView.backgroundColor = isSelected ? UIColor(resource: .lightGray) : .clear
        }
    }

    // MARK: - Private Properties

    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emojiBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
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

    func configure(with emoji: String) {
        emojiLabel.text = emoji
    }

    // MARK: - Private Methods

    private func setupUI() {
        contentView.addSubview(emojiBackgroundView)
        emojiBackgroundView.addSubview(emojiLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
        ])
    }
}
