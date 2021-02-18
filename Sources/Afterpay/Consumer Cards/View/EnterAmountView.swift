//
//  EnterAmountView.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 9/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import UIKit

final class EnterAmountView: UIView {

  var horizontalStackView: UIStackView = {
    let stackview = UIStackView()
    stackview.axis = .horizontal
    stackview.translatesAutoresizingMaskIntoConstraints = false
    stackview.spacing = 4

    return stackview
  }()

  var currencyLabel: UILabel = {
    let label = UILabel()
    label.text = "$"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true

    return label
  }()

  var amountField: UITextField = {
    let field = UITextField()
    field.keyboardType = .decimalPad
    field.textColor = .black

    let font = UIFont.boldSystemFont(ofSize: 56)
    field.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)

    field.adjustsFontForContentSizeCategory = true
    field.translatesAutoresizingMaskIntoConstraints = false

    return field
  }()

  var noteLabel: UILabel = {
    let label = UILabel()
    label.text = "Include shipping and tax in this amount"

    let font = UIFont.boldSystemFont(ofSize: 12)
    label.font = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: font)

    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true

    return label
  }()

  init(continueAction: Selector) {
    super.init(frame: .zero)

    let continueButton = PrimaryButton(title: "Continue")
    let titleLabel = TitleLabel(with: "Let's get started")
    let subtitleLabel = SubtitleLabel(with: "How much you want to spend?\nYou'll only be charged for what you end up using")

    currencyLabel.font = amountField.font
    currencyLabel.textColor = amountField.textColor

    continueButton.addTarget(inputViewController, action: continueAction, for: .touchUpInside)

    horizontalStackView.addArrangedSubview(currencyLabel)
    horizontalStackView.addArrangedSubview(amountField)

    addSubview(titleLabel)
    addSubview(subtitleLabel)
    addSubview(horizontalStackView)
    addSubview(noteLabel)
    addSubview(continueButton)

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      horizontalStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
      horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      horizontalStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),

      noteLabel.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 8),
      noteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      noteLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),

      continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      continueButton.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 24),
      continueButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
    ])

    let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    addGestureRecognizer(tap)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
