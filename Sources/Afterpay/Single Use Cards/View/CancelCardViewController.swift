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
  private let cancelAction: () -> Void

  init(cancelAction: @escaping () -> Void) {
    self.cancelAction = cancelAction
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    navigationItem.titleView = LogoView()

    titleLabel.text = "Do you want to cancel your single-use card?"

    bodyTextView.configure(with: """
    If you change your mind simply cancel the card and a refund will be issued for the first payment amount in an estimated 5-7 days (the exact timing depends on your financial institution).
    """
    )

    cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

    configureEditAmountTextView()
    addSubviews()
    setupConstraints()
  }

  @objc func cancelButtonTapped() {
    cancelAction()
  }

  private func configureEditAmountTextView() {
    let editAmountString = "Edit Card Amount"
    editAmountTextView.configure(with: """
    Or, if you want to update the value of your card to\na higher or lower value \(editAmountString)
    """
    )

    let attributedString = NSMutableAttributedString(attributedString: editAmountTextView.attributedText)
    let font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: .afterPayFont(weight: .bold, size: 14))
    let range = (attributedString.string as NSString).range(of: editAmountString)
    attributedString.addAttribute(.font, value: font, range: range)
    attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)

    editAmountTextView.attributedText = attributedString
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
      titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
      titleLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16),
    ]

    let bodyTextViewConstraints = [
      bodyTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
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
      cancelButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
    ]

    let editAmountViewConstraints = [
      editAmountTextView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 24),
      editAmountTextView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16),
      editAmountTextView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16),
      editAmountTextView.bottomAnchor.constraint(lessThanOrEqualTo: layoutGuide.bottomAnchor),
    ]

    let constraints = titleLabelConstraints
      + bodyTextViewConstraints
      + dividerConstraints
      + cancelButtonConstraints
      + editAmountViewConstraints

    NSLayoutConstraint.activate(constraints)
  }

  required init?(coder: NSCoder) {
    self.cancelAction = { }
    super.init(coder: coder)
  }
}
