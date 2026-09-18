//
//  ErrorAlertPresenting.swift
//  Tracker
//
//  Created by Ekaterina on 16.09.2026.
//

import UIKit

protocol ErrorAlertPresenting: UIViewController {
    func showErrorAlert(_ message: String)
    func confirmDeletion(message: String, onConfirm: @escaping () -> Void)
}

extension ErrorAlertPresenting {
    func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("common.ok", comment: "OK"), style: .default))
        present(alert, animated: true)
    }

    func confirmDeletion(message: String, onConfirm: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("common.delete", comment: ""), style: .destructive) { _ in onConfirm() })
        alert.addAction(UIAlertAction(title: NSLocalizedString("common.cancel", comment: ""), style: .cancel))
        present(alert, animated: true)
    }
}
