//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Ekaterina on 18.08.2026.
//

import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func didCreateTracker()
}

protocol NewTrackerViewControllerProtocol: AnyObject {
    var presenter: NewTrackerPresenterProtocol? { get set }
    func setCreateButtonEnabled(_ isEnabled: Bool)
    func updateTable(at row: Int)
}

final class NewTrackerViewController: UIViewController, NewTrackerViewControllerProtocol {

    // MARK: - Constants

    static let settingsItemsCellIdentifier = "settingsCell"

    // MARK: - Properties

    var presenter: NewTrackerPresenterProtocol?
    weak var delegate: NewTrackerViewControllerDelegate?

    // MARK: - Private Properties

    private let settingsItems = ["Категория", "Расписание"]
    
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
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.font = UIFont.systemFont(ofSize: 17)
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
        label.text = "Ограничение 38 символов"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(resource: .red)
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
        button.setTitle("Отменить", for: .normal)
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
        button.setTitle("Создать", for: .normal)
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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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

    // MARK: - Private Methods

    private func setupUI() {
        view.backgroundColor = UIColor(resource: .white)
        view.addSubview(scrollView)
    
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleTextLabel)
        contentView.addSubview(nameFieldStackView)
        contentView.addSubview(tableView)
        contentView.addSubview(buttonsStackView)

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
            titleTextLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 27),

            nameFieldStackView.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: 27),
            nameFieldStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameFieldStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),

            tableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: nameFieldStackView.bottomAnchor, constant: 27),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150),

            buttonsStackView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func didChangeName() {
        presenter?.didChangeName(nameTextField.text ?? "")
    }

    private func didTapCreate() {
        presenter?.didTapCreate()
        delegate?.didCreateTracker()
        dismiss(animated: true)
    }

    private func didTapCancel() {
        dismiss(animated: true)
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

        let isShorter = updatedText.count <= 38
        lengthWarningLabel.isHidden = isShorter

        return isShorter
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
        if indexPath.row == 1 {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            scheduleViewController.configure(selectedDays: presenter?.currentSchedule ?? [])
            present(scheduleViewController, animated: true)
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
        content.textProperties.font = UIFont.systemFont(ofSize: 17)
        content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 17)
        content.secondaryTextProperties.color = UIColor(resource: .gray)
        cell.contentConfiguration = content
        cell.isUserInteractionEnabled = indexPath.row != 0
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
