//
//  SuccessViewController.swift
//  Example
//
//  Created by Adam Campbell on 18/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class MessageViewController: UIViewController {

  private var messageLabel = UILabel()

  private let message: String
  private let token: Token

  init(message: String, token: Token) {
    self.message = message
    self.token = token

    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    view = UIView()
    view.backgroundColor = .appBackground

    messageLabel.text = message
    messageLabel.font = .preferredFont(forTextStyle: .body)
    messageLabel.adjustsFontForContentSizeCategory = true
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .natural
    messageLabel.textColor = .appLabel
    messageLabel.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(messageLabel)

    let layoutGuide = view.safeAreaLayoutGuide

    let labelConstraints = [
      messageLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16),
      messageLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 16),
      messageLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16),
    ]

    NSLayoutConstraint.activate(labelConstraints)
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
