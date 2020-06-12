//
//  DataEntryViewController.swift
//  Example
//
//  Created by Adam Campbell on 12/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import UIKit

final class DataEntryViewController: UIViewController, UITextFieldDelegate {

  private let didCheckout: (String) -> Void

  private var emailTextField: UITextField!
  private var centeringConstraint: NSLayoutConstraint!

  init(didCheckout: @escaping (String) -> Void) {
    self.didCheckout = didCheckout

    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    view = UIView()
    view.backgroundColor = .white

    emailTextField = UITextField()
    emailTextField.placeholder = "example@test.com"
    emailTextField.borderStyle = .roundedRect
    emailTextField.returnKeyType = .done
    emailTextField.delegate = self

    let submitButton = UIButton(type: .system)
    submitButton.setTitle("Checkout with Afterpay", for: .normal)
    submitButton.addTarget(self, action: #selector(didTapCheckout), for: .touchUpInside)

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

  // MARK: Checkout

  @objc private func didTapCheckout() {
    didCheckout(emailTextField.text ?? "")
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

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
