//
//  DictionaryView.swift
//  Pronounce
//
//  Created by asror on 05/02/26.
//

import UIKit
import SwiftUI

struct DictionaryView: UIViewControllerRepresentable {
    let term: String

    func makeUIViewController(context: Context) -> UIViewController {
        DictionaryContainerViewController(term: term)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // no-op
    }
}

final class DictionaryContainerViewController: UIViewController {
    private let term: String
    private var dictionaryVC: UIReferenceLibraryViewController?
    private let spinner = UIActivityIndicatorView(style: .large)

    init(term: String) {
        self.term = term
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()

        view.addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard dictionaryVC == nil else { return }

        guard UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: term) else {
            spinner.stopAnimating()
            showFallbackLabel()
            return
        }

        let vc = UIReferenceLibraryViewController(term: term)

        addChild(vc)
        vc.view.frame = view.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(vc.view)
        vc.didMove(toParent: self)

        dictionaryVC = vc
        spinner.stopAnimating()
    }

    private func showFallbackLabel() {
        let label = UILabel()
        label.text = "Definition not found for '\(term)'"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.frame = view.bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(label)
    }
}
