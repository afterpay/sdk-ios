//
//  DataEntryViewController.swift
//  Example
//
//  Created by Adam Campbell on 12/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import UIKit

final class DataEntryViewController: UIViewController {

  override func loadView() {
    view = UIView()
    view.backgroundColor = .white

    let emailTextField = UITextField()
    emailTextField.placeholder = "example@test.com"
    emailTextField.borderStyle = .roundedRect

    let submitButton = UIButton(type: .system)
    submitButton.setTitle("Checkout with Afterpay", for: .normal)

    let stackView = UIStackView(arrangedSubviews: [emailTextField, submitButton])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 8

    view.addSubview(stackView)

    let layoutGuide = view.readableContentGuide

    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
      stackView.topAnchor.constraint(greaterThanOrEqualTo: layoutGuide.topAnchor),
      stackView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
      stackView.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
    ])
  }

}
