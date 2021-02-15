//
//  LoadingView.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 15/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class LoadingView: UIView {
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

  init() {
    super.init(frame: .zero)

    loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
    addSubview(loadingSpinner)

    NSLayoutConstraint.activate([
      loadingSpinner.leadingAnchor.constraint(equalTo: leadingAnchor),
      loadingSpinner.trailingAnchor.constraint(equalTo: trailingAnchor),
      loadingSpinner.topAnchor.constraint(equalTo: topAnchor),
      loadingSpinner.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func startLoadingSpinner() {
    loadingSpinner.startAnimating()
  }

  func stopLoadingSpinner() {
    loadingSpinner.stopAnimating()
  }
}
