//
//  LoadingViewController.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 15/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class LoadingViewController: UIViewController {
  private var loadingSpinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView()
    spinner.hidesWhenStopped = false

    if #available(iOS 13.0, *) {
      spinner.style = .large
    } else {
      spinner.style = .whiteLarge
    }

    return spinner
  }()

  override func viewDidLoad() {
    loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(loadingSpinner)

    view.backgroundColor = .white
    loadingSpinner.backgroundColor = .white

    NSLayoutConstraint.activate([
      loadingSpinner.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      loadingSpinner.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      loadingSpinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      loadingSpinner.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    loadingSpinner.startAnimating()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    loadingSpinner.stopAnimating()
  }

  func startLoadingSpinner() {
    loadingSpinner.startAnimating()
  }

  func stopLoadingSpinner() {
    loadingSpinner.stopAnimating()
  }
}
