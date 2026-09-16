//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Ekaterina on 11.09.2026.
//

import UIKit

final class NewCategoryViewController: UIViewController, ErrorAlertPresenting {

    // MARK: - Constants

    private enum Constants {
        static let sideInset: CGFloat = 16
        static let sectionSpacing: CGFloat = 27
        static let nameFieldHeight: CGFloat = 75
        static let buttonsSideInset: CGFloat = 20
        static let buttonsHeight: CGFloat = 60
    }

    // MARK: - Private Properties

    private var viewModel: NewCategoryViewModel?

    private lazy var titleTextLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("newCategory.title", comment: "New category screen title")
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("newCategory.namePlaceholder", comment: "Category name field placeholder")
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
            self?.viewModel?.didChangeText(textField.text ?? "")
        }, for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var readyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("common.done", comment: "Done button title"), for: .normal)
        button.setTitleColor(UIColor(resource: .ypWhite), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.isEnabled = false
        button.backgroundColor = UIColor(resource: .gray)
        button.addAction(UIAction { [weak self] _ in
            self?.viewModel?.didTapDone()
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

    func initialize(viewModel: NewCategoryViewModel) {
        self.viewModel = viewModel
        bind()
    }

    // MARK: - Private Methods

    private func bind() {
        guard let viewModel = viewModel else { return }

        viewModel.onReadyStateChange = { [weak self] isEnabled in
            guard let self else { return }
            setCreateButtonEnabled(isEnabled)
        }

        viewModel.onError = { [weak self] message in
            self?.showErrorAlert(message)
        }
    }

    private func setCreateButtonEnabled(_ isEnabled: Bool) {
        readyButton.isEnabled = isEnabled
        readyButton.backgroundColor = UIColor(resource: isEnabled ? .ypBlack : .gray)
    }

    private func setupUI() {
        view.backgroundColor = UIColor(resource: .white)

        view.addSubview(titleTextLabel)
        view.addSubview(nameTextField)
        view.addSubview(readyButton)

        NSLayoutConstraint.activate([
            titleTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.sectionSpacing),

            nameTextField.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: Constants.sectionSpacing),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideInset),
            nameTextField.heightAnchor.constraint(equalToConstant: Constants.nameFieldHeight),

            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonsSideInset),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonsSideInset),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            readyButton.heightAnchor.constraint(equalToConstant: Constants.buttonsHeight)
        ])
    }
}
