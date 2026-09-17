//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Ekaterina on 02.08.2026.
//

import UIKit

protocol TrackersViewControllerProtocol: AnyObject, ErrorAlertPresenting {
    var presenter: TrackersPresenterProtocol? { get set }
    func showWelcomeScreen()
    func showSearchErrorScreen()
    func showTrackers()
    func reloadTrackers()
    func setDate(date: Date)
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
        static let filterButtonSideInset: CGFloat = 120
        static let filterButtonHeight: CGFloat = 50
        static let collectionBottomInset: CGFloat = 82
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

    private lazy var searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .error)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var welcomeTextLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("trackers.placeholder.empty", comment: "Empty trackers placeholder")
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var searchTextLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("trackers.placeholder.notFound", comment: "No search results placeholder")
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.overrideUserInterfaceStyle = .light
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale.current
        picker.backgroundColor = UIColor(resource: .datePicker)
        picker.layer.cornerRadius = 8
        picker.layer.masksToBounds = true
        picker.addAction(UIAction { [weak self] _ in
            self?.datePickerValueChanged()
        }, for: .valueChanged)
        return picker
    }()

    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("filter.title", comment: "Filter button title"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(resource: .ypBlue)
        button.addAction(UIAction { [weak self] _ in
            self?.didTapFilter()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let analytics = Analytics()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()

        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.reuseIdentifier)
        collectionView.register(TrackerSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSectionHeaderView.reuseIdentifier)
        collectionView.delegate = self

        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analytics.report(.open)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analytics.report(.close)
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
        searchImageView.isHidden = true
        searchTextLabel.isHidden = true
        filterButton.isHidden = true
    }

    func showSearchErrorScreen() {
        collectionView.isHidden = true
        starImageView.isHidden = true
        welcomeTextLabel.isHidden = true
        searchImageView.isHidden = false
        searchTextLabel.isHidden = false
        filterButton.isHidden = false
    }

    func showTrackers() {
        collectionView.isHidden = false
        starImageView.isHidden = true
        welcomeTextLabel.isHidden = true
        searchImageView.isHidden = true
        searchTextLabel.isHidden = true
        filterButton.isHidden = false
    }

    func reloadTrackers() {
        collectionView.reloadData()
    }

    func setDate(date: Date) {
        datePicker.date = date
    }

    // MARK: - Private Methods

    private func setupUI() {
        setupNavigationBar()
        view.backgroundColor = UIColor(resource: .ypWhite)
        view.addSubview(starImageView)
        view.addSubview(welcomeTextLabel)
        view.addSubview(searchImageView)
        view.addSubview(searchTextLabel)
        NSLayoutConstraint.activate([
            starImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Constants.placeholderCenterYOffset),
            starImageView.widthAnchor.constraint(equalToConstant: Constants.placeholderSize),
            starImageView.heightAnchor.constraint(equalToConstant: Constants.placeholderSize),

            welcomeTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeTextLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: Constants.placeholderTextSpacing),

            searchImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Constants.placeholderCenterYOffset),
            searchImageView.widthAnchor.constraint(equalToConstant: Constants.placeholderSize),
            searchImageView.heightAnchor.constraint(equalToConstant: Constants.placeholderSize),

            searchTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextLabel.topAnchor.constraint(equalTo: searchImageView.bottomAnchor, constant: Constants.placeholderTextSpacing),
        ])

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.collectionBottomInset, right: 0)
        collectionView.verticalScrollIndicatorInsets.bottom = Constants.collectionBottomInset
        view.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.sideInset),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.filterButtonSideInset),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.filterButtonSideInset),
            filterButton.heightAnchor.constraint(equalToConstant: Constants.filterButtonHeight)
        ])
    }

    private func setupNavigationBar() {
        title = NSLocalizedString("trackers.title", comment: "Trackers navigation title")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .plus),
            primaryAction: UIAction { [weak self] _ in
                self?.didTapAddTracker()
            }
        )
        navigationItem.leftBarButtonItem?.tintColor = UIColor(resource: .ypBlack)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    private func didTapAddTracker() {
        let newTrackerViewController = NewTrackerViewController()
        newTrackerViewController.configure(NewTrackerPresenter())
        present(newTrackerViewController, animated: true)
        analytics.report(.click, item: .addTrack)
    }

    private func datePickerValueChanged() {
        presenter?.didSelectDate(datePicker.date)
    }

    private func showDeleteConfirmation(at indexPath: IndexPath) {
        confirmDeletion(message: NSLocalizedString("tracker.delete.confirm", comment: "Confirm delete message")) { [weak self] in
            self?.presenter?.didTapDelete(at: indexPath.section, indexPath.row)
        }
    }

    private func didTapFilter() {
        let vc = FilterViewController(selectedFilter: presenter?.currentFilter ?? .all)
        vc.delegate = self
        present(vc, animated: true)
        analytics.report(.click, item: .filter)
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.numberOfTrackers(in: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.reuseIdentifier, for: indexPath)

        guard let trackerCell = cell as? TrackersCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let trackerModel = presenter?.tracker(at: indexPath.section, indexPath.row) else {
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

        guard kind == UICollectionView.elementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerSectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? TrackerSectionHeaderView else {
            return UICollectionReusableView()
        }
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

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }

        return UIContextMenuConfiguration(actionProvider: { _ in
            UIMenu(children: [
                UIAction(title: NSLocalizedString("common.edit", comment: "Edit tracker with context menu")) { [weak self] _ in
                    let data = self?.presenter?.trackerForEditing(at: indexPath.section, indexPath.row)
                    let vc = NewTrackerViewController()
                    let trackerDraft = TrackerDraft(
                        id: data?.tracker.id,
                        name: data?.tracker.title ?? "",
                        emoji: data?.tracker.emoji,
                        color: data?.tracker.color,
                        schedule: data?.tracker.schedule ?? [],
                        category: data?.category ?? ""
                    )
                    vc.configure(NewTrackerPresenter(currentTracker: trackerDraft, completedDays: data?.days ?? 0))
                    self?.present(vc, animated: true)
                    self?.analytics.report(.click, item: .edit)
                },
                UIAction(title: NSLocalizedString("common.delete", comment: "Delete tracker with context menu"), attributes: .destructive) { [weak self] _ in
                    self?.showDeleteConfirmation(at: indexPath)
                    self?.analytics.report(.click, item: .delete)
                },
            ])
        })
    }

    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfiguration configuration: UIContextMenuConfiguration,
        highlightPreviewForItemAt indexPath: IndexPath
    ) -> UITargetedPreview? {
        guard let trackerCell = collectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell else {
            return nil
        }
        return UITargetedPreview(view: trackerCell.cardView)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfiguration configuration: UIContextMenuConfiguration,
        dismissalPreviewForItemAt indexPath: IndexPath
    ) -> UITargetedPreview? {
        guard let trackerCell = collectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell else {
            return nil
        }
        return UITargetedPreview(view: trackerCell.cardView)
    }
}

// MARK: - UISearchResultsUpdating

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter?.didChangeSearchText(searchController.searchBar.text ?? "")
    }
}

// MARK: - TrackersCollectionViewCellDelegate

extension TrackersViewController: TrackersCollectionViewCellDelegate {
    func trackerCollectionViewCellDidTapComplete(_ cell: TrackersCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        presenter?.didTapComplete(at: indexPath.section, indexPath.row)
        analytics.report(.click, item: .track)
    }
}

// MARK: - FilterViewControllerDelegate

extension TrackersViewController: FilterViewControllerDelegate {
    func didSelectFilter(_ filter: TrackerFilter) {
        presenter?.didSelectFilter(filter)
    }
}
