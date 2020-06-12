//
//  DataEntryViewController.swift
//  Example
//
//  Created by Adam Campbell on 12/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import UIKit

final class DataEntryViewController: UIViewController, UITextFieldDelegate {

  private var centeringConstraint: NSLayoutConstraint!

  override func loadView() {
    view = UIView()
    view.backgroundColor = .white

    let emailTextField = UITextField()
    emailTextField.placeholder = "example@test.com"
    emailTextField.borderStyle = .roundedRect
    emailTextField.returnKeyType = .done
    emailTextField.delegate = self

    let submitButton = UIButton(type: .system)
    submitButton.setTitle("Checkout with Afterpay", for: .normal)

    let stackView = UIStackView(arrangedSubviews: [emailTextField, submitButton])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 8

    view.addSubview(stackView)

    let layoutGuide = view.readableContentGuide

    centeringConstraint = stackView.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor)

    NSLayoutConstraint.activate([
      centeringConstraint,
      stackView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
      stackView.topAnchor.constraint(greaterThanOrEqualTo: layoutGuide.topAnchor),
      stackView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
    ])
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let notificationCenter = NotificationCenter.default

    notificationCenter.addObserver(
      self,
      selector: #selector(adjustForKeyboard),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )

    notificationCenter.addObserver(
      self,
      selector: #selector(adjustForKeyboard),
      name: UIResponder.keyboardWillChangeFrameNotification,
      object: nil
    )
  }

  // MARK: UITextFieldDelegate

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  // MARK: Keyboard Handling

  @objc private func adjustForKeyboard(notification: Notification) {
    let endFrameKey = UIResponder.keyboardFrameEndUserInfoKey
    guard let keyboardValue = notification.userInfo?[endFrameKey] as? NSValue else { return }

    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

    if notification.name == UIResponder.keyboardWillHideNotification {
      centeringConstraint.constant = 0
    } else {
      let layoutGuide = view.readableContentGuide
      centeringConstraint.constant = keyboardViewEndFrame.origin.y - layoutGuide.layoutFrame.midY
    }

    UIView.animate(withDuration: 0.5) {
      self.view.layoutIfNeeded()
    }
  }

}
