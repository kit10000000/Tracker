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

    private enum Constants {
        static let sectionSpacing: CGFloat = 27
        static let sideInset: CGFloat = 16
        static let tableHeight: CGFloat = 525
        static let buttonsSideInset: CGFloat = 20
        static let buttonsHeight: CGFloat = 60
    }

    // MARK: - Properties

    weak var delegate: ScheduleViewControllerDelegate?

    // MARK: - Private Properties

    private var selectedDays: Set<WeekDay> = []

    private lazy var titleTextLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("schedule.title", comment: "Schedule screen title")
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
        button.setTitle(NSLocalizedString("common.done", comment: "Done button title"), for: .normal)
        button.setTitleColor(UIColor(resource: .ypWhite), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(resource: .blackDay)
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
            titleTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.sectionSpacing),

            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: Constants.sectionSpacing),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideInset),
            tableView.heightAnchor.constraint(equalToConstant: Constants.tableHeight),

            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonsSideInset),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonsSideInset),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            readyButton.heightAnchor.constraint(equalToConstant: Constants.buttonsHeight)
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
