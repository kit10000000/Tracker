//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Ekaterina on 02.08.2026.
//

import UIKit

protocol TrackersViewControllerProtocol: AnyObject {
    var presenter: TrackersPresenterProtocol? { get set }
    func showWelcomeScreen()
    func showTrackers()
    func reloadTrackers()
    func reloadTracker(at section: Int, _ index: Int)
}

final class TrackersViewController: UIViewController, TrackersViewControllerProtocol {

    // MARK: - Constants

    private enum Constants {
        static let placeholderSize: CGFloat = 80
        static let placeholderCenterYOffset: CGFloat = 36
        static let placeholderTextSpacing: CGFloat = 8
        static let sideInset: CGFloat = 16
        static let interItemSpacing: CGFloat = 9
        static let cellHeight: CGFloat = 148
        static let headerHeight: CGFloat = 46
    }

    // MARK: - Properties

    var presenter: TrackersPresenterProtocol?

    // MARK: - Private Properties

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .star)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var welcomeTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        picker.addAction(UIAction { [weak self] _ in
            self?.datePickerValueChanged()
        }, for: .valueChanged)
        return picker
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()

        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier)
        collectionView.register(TrackerSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSectionHeaderView.reuseIdentifier)
        collectionView.delegate = self

        setupUI()
    }

    // MARK: - Methods

    func configure(_ presenter: TrackersPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }

    func showWelcomeScreen() {
        collectionView.isHidden = true
        starImageView.isHidden = false
        welcomeTextLabel.isHidden = false
    }

    func showTrackers() {
        collectionView.isHidden = false
        starImageView.isHidden = true
        welcomeTextLabel.isHidden = true
    }

    func reloadTrackers() {
        collectionView.reloadData()
    }

    func reloadTracker(at section: Int, _ index: Int) {
        let indexPath = IndexPath(row: index, section: section)
        collectionView.reloadItems(at: [indexPath])
    }

    // MARK: - Private Methods

    private func setupUI() {
        setupNavigationBar()
        view.backgroundColor = UIColor(resource: .ypWhite)
        view.addSubview(starImageView)
        view.addSubview(welcomeTextLabel)
        NSLayoutConstraint.activate([
            starImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Constants.placeholderCenterYOffset),
            starImageView.widthAnchor.constraint(equalToConstant: Constants.placeholderSize),
            starImageView.heightAnchor.constraint(equalToConstant: Constants.placeholderSize),

            welcomeTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeTextLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: Constants.placeholderTextSpacing),
        ])

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collectionView.dataSource = self
    }

    private func setupNavigationBar() {
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .plus),
            primaryAction: UIAction { [weak self] _ in
                self?.didTapAddTracker()
            }
        )
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "YP Black")

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    private func didTapAddTracker() {
       print("tapped AddTracker")
    }

    private func datePickerValueChanged() {
        presenter?.didSelectDate(datePicker.date)
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.numberOfTrackers(in: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier, for: indexPath)

        guard let trackerCell = cell as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let trackerModel = presenter?.tracker(at: indexPath.section, indexPath.row, on: datePicker.date) else {
            return UICollectionViewCell()
        }
        trackerCell.delegate = self
        trackerCell.configure(with: trackerModel)
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter?.categoriesCount ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = TrackerSectionHeaderView.reuseIdentifier
        default:
            id = ""
        }

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! TrackerSectionHeaderView
        view.configure(title: presenter?.categoryTitle(at: indexPath.section) ?? "")
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: Constants.headerHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - Constants.sideInset * 2 - Constants.interItemSpacing
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.interItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: Constants.sideInset, bottom: 0, right: Constants.sideInset)
    }
}

// MARK: - UISearchResultsUpdating

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter?.didChangeSearchText(searchController.searchBar.text ?? "")
    }
}

// MARK: - ImagesListCellDelegate

extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func trackerCollectionViewCellDidTapComplete(_ cell: TrackerCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        presenter?.didTapComplete(at: indexPath.section, indexPath.row, on: datePicker.date)
    }
}
