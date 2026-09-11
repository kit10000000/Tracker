//
//  CategoryListViewController.swift
//  Tracker
//
//  Created by Ekaterina on 10.09.2026.
//

import UIKit

final class CategoryListViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let sectionSpacing: CGFloat = 27
        static let sideInset: CGFloat = 16
        static let buttonsSideInset: CGFloat = 20
        static let buttonsHeight: CGFloat = 60
    }

    // MARK: - Private Properties

    private var viewModel: CategoryListViewModel?
    private var tableHeightConstraint: NSLayoutConstraint?

    private lazy var titleTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
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
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()

    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить Категорию", for: .normal)
        button.setTitleColor(UIColor(resource: .ypWhite), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(resource: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Methods

    func initialize(viewModel: CategoryListViewModel) {
        self.viewModel = viewModel
        bind()
        viewModel.loadCategories()
    }

    // MARK: - Private Methods

    private func bind() {
        guard let viewModel = viewModel else { return }

        viewModel.onCategoriesChange = { [weak self] categories in
            guard let self else { return }
            self.tableView.reloadData()
            self.tableHeightConstraint?.constant = CGFloat(categories.count) * self.tableView.rowHeight
        }
    }

    private func setupUI() {
        view.backgroundColor = UIColor(resource: .white)
        view.addSubview(titleTextLabel)
        view.addSubview(tableView)
        view.addSubview(createButton)

        let rowCount = viewModel?.numberOfRows() ?? 0
        let tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: CGFloat(rowCount) * tableView.rowHeight)
        self.tableHeightConstraint = tableHeightConstraint

        NSLayoutConstraint.activate([
            titleTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.sectionSpacing),

            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: Constants.sectionSpacing),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideInset),
            tableHeightConstraint,

            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonsSideInset),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonsSideInset),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: Constants.buttonsHeight)
        ])
    }
}

// MARK: - UITableViewDelegate

extension CategoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectCategory(at: indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension CategoryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath)

        guard let categoryListCell = cell as? CategoryTableViewCell,
              let cellModel = viewModel?.cell(at: indexPath.row) else {
            return UITableViewCell()
        }
        categoryListCell.configure(with: cellModel)
        let lastIndex = (viewModel?.numberOfRows() ?? 0) - 1
        if indexPath.row == lastIndex {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return categoryListCell
    }
}
