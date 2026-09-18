//
//  FilterViewController.swift
//  Tracker
//
//  Created by Ekaterina on 16.09.2026.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didSelectFilter(_ filter: TrackerFilter)
}

final class FilterViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let sideInset: CGFloat = 16
        static let rowHeight: CGFloat = 75
        static let titleTopSpacing: CGFloat = 27
        static let tableTopSpacing: CGFloat = 24
    }

    // MARK: - Properties

    weak var delegate: FilterViewControllerDelegate?

    // MARK: - Private Properties

    private let filters = TrackerFilter.allCases
    private var selectedFilter: TrackerFilter

    private lazy var titleTextLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("filter.title", comment: "Category screen title")
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = Constants.cornerRadius
        tableView.layer.masksToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = Constants.rowHeight
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: Constants.sideInset, bottom: 0, right: Constants.sideInset)
        return tableView
    }()

    // MARK: - Initializers

    init(selectedFilter: TrackerFilter = .all) {
        self.selectedFilter = selectedFilter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private Methods

    private func setupUI() {
        view.backgroundColor = UIColor(resource: .white)
        view.addSubview(titleTextLabel)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            titleTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTopSpacing),

            tableView.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: Constants.tableTopSpacing),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideInset),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(filters.count) * Constants.rowHeight)
        ])
    }
}

// MARK: - UITableViewDelegate

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFilter = filters[indexPath.row]
        tableView.reloadData()
        delegate?.didSelectFilter(selectedFilter)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryTableViewCell else {
            return UITableViewCell()
        }

        let filter = filters[indexPath.row]
        cell.configure(with: CategoryCellModel(
            title: filter.title,
            isSelected: (filter == selectedFilter && selectedFilter != .all && selectedFilter != .today)
        ))

        let lastIndex = filters.count - 1
        if indexPath.row == lastIndex {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: Constants.sideInset, bottom: 0, right: Constants.sideInset)
        }
        return cell
    }
}
