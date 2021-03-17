//
//  CancelCardViewController.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 17/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class CancelCardViewController: UIViewController {
  private let titleLabel = TitleLabel(fontSize: 24)
  private let bodyTextView = BodyTextView()
  private let editAmountTextView = BodyTextView()
  private let divider = DividerView()
  private let cancelButton = PrimaryButton(title: "Cancel single-use card")

  override func viewDidLoad() {
    super.viewDidLoad()

    bodyTextView.configure(with: """
    If you change your mind simply cancel the card and a refund will be issued for the first payment amount in an extimated 5-7 days (the exact timing depends on your financial institution).
    """
    )

    editAmountTextView.configure(with: """
    Or, if you want to update the value of your card to\na higher or lower value Edit Card Amount
    """
    )

    addSubviews()
    setupConstraints()
  }

  private func addSubviews() {
    view.addSubview(titleLabel)
    view.addSubview(bodyTextView)
    view.addSubview(divider)
    view.addSubview(editAmountTextView)
    view.addSubview(cancelButton)
  }

  private func setupConstraints() {
    let layoutGuide = view.safeAreaLayoutGuide

    let titleLabelConstraints = [
      titleLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 32),
      titleLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16),
    ]

    let bodyTextViewConstraints = [
      bodyTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
      bodyTextView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16),
      bodyTextView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16),
    ]

    let dividerConstraints = [
      divider.topAnchor.constraint(equalTo: bodyTextView.bottomAnchor, constant: 24),
      divider.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16),
      divider.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16),
    ]

    let cancelButtonConstraints = [
      cancelButton.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 32),
      cancelButton.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16),
      cancelButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16),
      cancelButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64)
    ]

    let editAmountViewConstraints = [
      editAmountTextView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 24),
      editAmountTextView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16),
      editAmountTextView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16),
      editAmountTextView.bottomAnchor.constraint(lessThanOrEqualTo: layoutGuide.bottomAnchor)
    ]

    let constraints = titleLabelConstraints + bodyTextViewConstraints + dividerConstraints + cancelButtonConstraints + editAmountViewConstraints

    NSLayoutConstraint.activate(constraints)
  }
}
