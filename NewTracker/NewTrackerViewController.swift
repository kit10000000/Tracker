//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Ekaterina on 18.08.2026.
//

import UIKit

protocol NewTrackerViewControllerProtocol: AnyObject, ErrorAlertPresenting {
    var presenter: NewTrackerPresenterProtocol? { get set }
    func setCreateButtonEnabled(_ isEnabled: Bool)
    func updateTable(at row: Int)
    func dismissForm()
}

final class NewTrackerViewController: UIViewController, NewTrackerViewControllerProtocol {

    // MARK: - Constants

    static let settingsItemsCellIdentifier = "settingsCell"

    private enum Constants {
        static let sideInset: CGFloat = 16
        static let sectionSpacing: CGFloat = 27

        static let nameFieldHeight: CGFloat = 75
        static let tableHeight: CGFloat = 150

        static let itemsPerRow: CGFloat = 6
        static let cellHeight: CGFloat = 52
        static let sectionInset: CGFloat = 8
        static let interItemSpacing: CGFloat = 2
        static let lineSpacing: CGFloat = 7
        static let rowsPerSection: CGFloat = 3
        static let collectionHeaderHeight: CGFloat = 46

        static let buttonsSideInset: CGFloat = 20
        static let buttonsTopSpacing: CGFloat = 20
        static let buttonsHeight: CGFloat = 60
        static let settingsCellFontSize: CGFloat = 17
    }

    private enum TrackerSection: Int, CaseIterable {
        case emoji, color
    }

    private enum SettingsRow: Int {
        case category
        case schedule
    }

    // MARK: - Properties

    var presenter: NewTrackerPresenterProtocol?

    // MARK: - Private Properties

    private let settingsItems = [
        NSLocalizedString("category.title", comment: "Category settings row title"),
        NSLocalizedString("schedule.title", comment: "Schedule settings row title")
    ]

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("newTracker.namePlaceholder", comment: "Tracker name field placeholder")
        textField.font = UIFont.systemFont(ofSize: Constants.settingsCellFontSize)
        textField.backgroundColor = UIColor(resource: .background)
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.addAction(UIAction { [weak self] _ in
            self?.didChangeName()
        }, for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    private lazy var lengthWarningLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("newTracker.nameLimit", comment: "Tracker name length limit warning")
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(resource: .red)
        label.isHidden = true
        return label
    }()

    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = .ypBlack
        label.isHidden = true
        return label
    }()

    private lazy var nameFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, lengthWarningLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [daysLabel, nameFieldStackView])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 75
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NewTrackerViewController.settingsItemsCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("common.cancel", comment: "Cancel button title"), for: .normal)
        button.setTitleColor(UIColor(resource: .red), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(resource: .red).cgColor
        button.addAction(UIAction { [weak self] _ in
            self?.didTapCancel()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("common.create", comment: "Create button title"), for: .normal)
        button.setTitleColor(UIColor(resource: .ypWhite), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.isEnabled = false
        button.backgroundColor = UIColor(resource: .gray)
        button.addAction(UIAction { [weak self] _ in
            self?.didTapCreate()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier)
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifier)
        collectionView.register(NewTrackerSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NewTrackerSectionHeaderView.reuseIdentifier)
        collectionView.delegate = self
    }

    // MARK: - Methods

    func configure(_ presenter: NewTrackerPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }

    func setCreateButtonEnabled(_ isEnabled: Bool) {
        createButton.isEnabled = isEnabled
        if isEnabled {
            createButton.backgroundColor = UIColor(resource: .ypBlack)
        } else {
            createButton.backgroundColor = UIColor(resource: .gray)
        }
    }

    func updateTable(at row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }

    func dismissForm() {
        dismiss(animated: true)
    }

    // MARK: - Private Methods

    private func setupUI() {
        view.backgroundColor = UIColor(resource: .white)
        view.addSubview(scrollView)

        scrollView.addSubview(contentView)

        contentView.addSubview(titleTextLabel)
        contentView.addSubview(topStackView)
        contentView.addSubview(tableView)
        contentView.addSubview(collectionView)
        contentView.addSubview(buttonsStackView)

        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self

        let sectionHeight = Constants.cellHeight * Constants.rowsPerSection
                          + Constants.lineSpacing * (Constants.rowsPerSection - 1)
                          + Constants.collectionHeaderHeight

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            titleTextLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleTextLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: Constants.sectionSpacing),

            topStackView.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: Constants.sectionSpacing),
            topStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.sideInset),
            topStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.sideInset),
            nameTextField.heightAnchor.constraint(equalToConstant: Constants.nameFieldHeight),

            tableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: Constants.sectionSpacing),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.sideInset),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.sideInset),
            tableView.heightAnchor.constraint(equalToConstant: Constants.tableHeight),

            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: Constants.sectionSpacing),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: sectionHeight * 2),

            buttonsStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: Constants.buttonsTopSpacing),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.buttonsSideInset),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.buttonsSideInset),
            buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: Constants.buttonsHeight)
        ])
        prefill()
    }

    private func didChangeName() {
        presenter?.didChangeName(nameTextField.text ?? "")
    }

    private func didTapCreate() {
        presenter?.didTapCreate()
    }

    private func didTapCancel() {
        dismiss(animated: true)
    }

    private func prefill() {
        guard let presenter else { return }

        titleTextLabel.text = presenter.screenTitle
        createButton.setTitle(presenter.buttonTitle, for: .normal)
        nameTextField.text = presenter.currentName

        daysLabel.isHidden = !presenter.isEditing
        daysLabel.text = presenter.completedDaysText

        tableView.reloadData()
        collectionView.reloadData()

        if let emojiIndex = presenter.selectedEmojiIndex {
            collectionView.selectItem(at: IndexPath(item: emojiIndex, section: 0), animated: false, scrollPosition: [])
        }
        if let colorIndex = presenter.selectedColorIndex {
            collectionView.selectItem(at: IndexPath(item: colorIndex, section: 1), animated: false, scrollPosition: [])
        }
        setCreateButtonEnabled(presenter.isFormValid)
    }
}

// MARK: - UITextFieldDelegate

extension NewTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)

        let isWithinLimit = presenter?.isWithinNameLengthLimit(updatedText) ?? true
        lengthWarningLabel.isHidden = isWithinLimit
        return isWithinLimit
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        lengthWarningLabel.isHidden = true
        return true
    }
}

// MARK: - UITableViewDelegate

extension NewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch SettingsRow(rawValue: indexPath.row) {
        case .category:
            let viewModel = CategoryListViewModel(selectedCategory: presenter?.currentCategory)
            let categoryViewController = CategoryListViewController()
            categoryViewController.initialize(viewModel: viewModel)

            viewModel.onCategorySelect = { [weak self] title in
                self?.presenter?.didSelectCategory(title)
                if !title.isEmpty {
                    self?.dismiss(animated: true)
                }
            }

            present(categoryViewController, animated: true)
        case .schedule:
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            scheduleViewController.configure(selectedDays: presenter?.currentSchedule ?? [])
            present(scheduleViewController, animated: true)
        case .none:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewTrackerViewController.settingsItemsCellIdentifier, for: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }

    private func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        var content = cell.defaultContentConfiguration()
        content.text = settingsItems[indexPath.row]
        content.secondaryText = presenter?.subtitle(for: indexPath.row)
        content.textProperties.font = UIFont.systemFont(ofSize: Constants.settingsCellFontSize)
        content.secondaryTextProperties.font = UIFont.systemFont(ofSize: Constants.settingsCellFontSize)
        content.secondaryTextProperties.color = UIColor(resource: .gray)
        cell.contentConfiguration = content
        cell.isUserInteractionEnabled = true
        cell.backgroundColor = UIColor(resource: .background)
        cell.accessoryType = .disclosureIndicator
        if indexPath.row == settingsItems.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: 0, bottom: 0.0, right: UIScreen.main.bounds.width)
        }
    }
}

// MARK: - ScheduleViewControllerDelegate

extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func didConfirmSchedule(_ schedule: [WeekDay]) {
        presenter?.didSelectSchedule(schedule)
    }
}

// MARK: - UICollectionViewDataSource

extension NewTrackerViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        TrackerSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch TrackerSection(rawValue: section) {
        case .emoji: return presenter?.emojis.count ?? 0
        case .color: return presenter?.colors.count ?? 0
        case .none: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch TrackerSection(rawValue: indexPath.section) {
        case .emoji: return configureEmojiCell(for: indexPath)
        case .color: return configureColorCell(for: indexPath)
        case .none:  return UICollectionViewCell()
        }
    }

    private func configureEmojiCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier, for: indexPath)
        guard let emojiCell = cell as? EmojiCollectionViewCell,
              let emoji = presenter?.emojis[indexPath.row] else {
            return UICollectionViewCell()
        }
        emojiCell.configure(with: emoji)
        return emojiCell
    }

    private func configureColorCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier, for: indexPath)
        guard let colorCell = cell as? ColorCollectionViewCell,
              let color = presenter?.colors[indexPath.row] else {
            return UICollectionViewCell()
        }
        colorCell.configure(with: color)
        return colorCell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: NewTrackerSectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? NewTrackerSectionHeaderView else {
            return UICollectionReusableView()
        }
        switch TrackerSection(rawValue: indexPath.section) {
        case .emoji: view.configure(title: presenter?.emojiSectionTitle ?? "")
        case .color: view.configure(title: presenter?.colorSectionTitle ?? "")
        case .none:  view.configure(title: "")
        }
        return view
    }
}

// MARK: - UICollectionViewDelegate

extension NewTrackerViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.indexPathsForSelectedItems?
                .filter { $0.section == indexPath.section && $0 != indexPath }
                .forEach { collectionView.deselectItem(at: $0, animated: false) }
        switch TrackerSection(rawValue: indexPath.section) {
        case .emoji: presenter?.didSelectEmoji(at: indexPath.row)
        case .color: presenter?.didSelectColor(at: indexPath.row)
        case .none: return
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: Constants.collectionHeaderHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width
            - Constants.sectionInset * 2
            - Constants.interItemSpacing * (Constants.itemsPerRow - 1)
        let cellWidth = availableWidth / Constants.itemsPerRow
        return CGSize(width: cellWidth, height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.interItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.lineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: Constants.sectionInset, bottom: 0, right: Constants.sectionInset)
    }
}
