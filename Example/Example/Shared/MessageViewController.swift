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
  private var widgetView: WidgetView!

  private let updateAmountField = Field(
    text: "Total Amount:",
    placeholder: "0.00",
    keyboardType: .decimalPad,
    target: self,
    action: #selector(updateAmountTapped)
  )

  private let getStatusButton = UIButton(type: .system)

  private let message: String
  private let token: Token?

  init(message: String, token: Token?) {
    self.message = message
    self.token = token

    super.init(nibName: nil, bundle: nil)

    self.title = message
  }

  override func loadView() {
    view = UIView()
    view.backgroundColor = .appBackground

    setupMessageLabel()
    try? setupWidget()
    setupUpdateAmountField()
    setupGetStatusButton()
  }

  private func setupMessageLabel() {
    guard AfterpayFeatures.widgetEnabled == false else { return }

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

  private func setupWidget() throws {
    guard AfterpayFeatures.widgetEnabled else { return }

    if let token = token {
      widgetView = try WidgetView(token: token)
    } else {
      widgetView = try WidgetView(amount: "200.00", style: WidgetView.Style(logo: false, heading: true))
    }
    widgetView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(widgetView)

    let layoutGuide = view.safeAreaLayoutGuide

    let constraints = [
      widgetView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 16),
      widgetView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16),
      widgetView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16),
    ]

    NSLayoutConstraint.activate(constraints)
  }

  private func setupUpdateAmountField() {
    guard AfterpayFeatures.widgetEnabled else { return }

    view.addSubview(updateAmountField)

    let layoutGuide = view.safeAreaLayoutGuide

    NSLayoutConstraint.activate(
      [
        updateAmountField.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16),
        updateAmountField.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16),
        updateAmountField.topAnchor.constraint(equalTo: widgetView.bottomAnchor, constant: 16),
      ]
    )
  }

  private func setupGetStatusButton() {
    guard AfterpayFeatures.widgetEnabled else { return }

    getStatusButton.setTitle("Print status to console", for: .normal)
    getStatusButton.translatesAutoresizingMaskIntoConstraints = false
    getStatusButton.addTarget(self, action: #selector(getStatusTapped), for: .touchUpInside)
    getStatusButton.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(getStatusButton)

    let layoutGuide = view.safeAreaLayoutGuide

    let constraints = [
      getStatusButton.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16),
      getStatusButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16),
      getStatusButton.topAnchor.constraint(equalTo: updateAmountField.bottomAnchor, constant: 16),
    ]

    NSLayoutConstraint.activate(constraints)
  }

  @objc private func updateAmountTapped() throws {
    try widgetView.sendUpdate(
      amount: updateAmountField.text ?? ""
    )
  }

  @objc private func getStatusTapped() {
    DispatchQueue.main.async { [widgetView] in
      widgetView?.getStatus { result in
        switch result {
        case .failure(let error):
          print("Sorry: \(error.localizedDescription)")
        case .success(let status):
          print("Status: \(status)")
        }
      }
    }

  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

private class Field: UIStackView {

  private let label = UILabel()
  private let textField = UITextField()
  private let button = UIButton(type: .system)

  var text: String? { textField.text }

  init(
    text: String,
    placeholder: String = "…",
    keyboardType: UIKeyboardType,
    target: Any?,
    action: Selector
  ) {
    label.text = text
    label.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)

    textField.placeholder = placeholder
    textField.keyboardType = keyboardType

    button.setTitle("Update", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(target, action: action, for: .touchUpInside)
    button.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .horizontal)

    super.init(frame: .zero)

    translatesAutoresizingMaskIntoConstraints = false
    axis = .horizontal
    spacing = 8

    [label, textField, button].forEach(addArrangedSubview)
  }

  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
