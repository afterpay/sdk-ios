//
//  SuccessViewController.swift
//  Example
//
//  Created by Adam Campbell on 18/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
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

    setupMessageLabel()
    setupWidget()
  }

  private func setupMessageLabel() {
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
      messageLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 16),
      messageLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16),
      messageLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16),
    ]

    NSLayoutConstraint.activate(labelConstraints)
  }

  private func setupWidget() {
    guard AfterpayFeatures.widgetEnabled else { return }

    let widgetView = WidgetView(token: token)

    view.addSubview(widgetView)

    let layoutGuide = view.safeAreaLayoutGuide

    widgetView.translatesAutoresizingMaskIntoConstraints = false

    let constraints = [
      widgetView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: 32),
      widgetView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16),
      widgetView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16),
      widgetView.heightAnchor.constraint(equalToConstant: 350),
    ]

    NSLayoutConstraint.activate(constraints)
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
