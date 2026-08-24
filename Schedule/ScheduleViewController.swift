//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Ekaterina on 21.08.2026.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didConfirmSchedule(_ schedule: [WeekDay])
}

final class ScheduleViewController: UIViewController {

    // MARK: - Constants

    static let weekdayCellIdentifier = "weekdayCell"

    // MARK: - Properties

    weak var delegate: ScheduleViewControllerDelegate?

    // MARK: - Private Properties

    private var selectedDays: Set<WeekDay> = []

    private lazy var titleTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 75
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ScheduleViewController.weekdayCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()

    private lazy var readyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(UIColor(resource: .ypWhite), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(resource: .black)
        button.addAction(UIAction { [weak self] _ in
            self?.didTapReady()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Methods

    func configure(selectedDays: [WeekDay]) {
        self.selectedDays = Set(selectedDays)
    }

    // MARK: - Private Methods

    private func setupUI() {
        view.backgroundColor = UIColor(resource: .white)
        view.addSubview(titleTextLabel)
        view.addSubview(tableView)
        view.addSubview(readyButton)

        NSLayoutConstraint.activate([
            titleTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),

            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: 27),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),

            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func didTapReady() {
        delegate?.didConfirmSchedule(selectedDays.sorted { $0.rawValue < $1.rawValue })
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleViewController.weekdayCellIdentifier, for: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }

    private func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        var content = cell.defaultContentConfiguration()
        let day = WeekDay.allCases[indexPath.row]
        content.text = day.fullName
        cell.contentConfiguration = content
        cell.backgroundColor = UIColor(resource: .background)

        let daySwitch = UISwitch()
        daySwitch.onTintColor = UIColor(resource: .ypBlue)
        daySwitch.isOn = selectedDays.contains(day)
        daySwitch.addAction(UIAction { [weak self] action in
            guard let daySwitch = action.sender as? UISwitch else { return }
            if daySwitch.isOn {
                self?.selectedDays.insert(day)
            } else {
                self?.selectedDays.remove(day)
            }
        }, for: .valueChanged)
        cell.accessoryView = daySwitch
        if indexPath.row == WeekDay.allCases.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: 0, bottom: 0.0, right: UIScreen.main.bounds.width)
        }
    }
}
