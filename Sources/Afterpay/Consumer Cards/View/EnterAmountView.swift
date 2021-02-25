//
//  EnterAmountView.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 9/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import UIKit

final class EnterAmountView: UIView {

  var enterAmountContainerView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.layer.cornerRadius = 12
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.virtualCardTextColor.cgColor
    view.translatesAutoresizingMaskIntoConstraints = false

    return view
  }()

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

    let font = UIFont.afterPayFont(weight: .bold, size: 56)
    field.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)

    field.adjustsFontForContentSizeCategory = true
    field.translatesAutoresizingMaskIntoConstraints = false

    return field
  }()

  var noteLabel: UILabel = {
    let label = UILabel()
    label.text = "Include shipping and tax in this amount."

    let font = UIFont.afterPayFont(weight: .bold, size: 14)
    label.font = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: font)

    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true

    return label
  }()

  init(continueAction: Selector, merchantName: String) {
    super.init(frame: .zero)

    let continueButton = PrimaryButton(title: "Continue")
    let titleLabel = TitleLabel(with: "Let's get started")
    let firstSubtitleLabel = SubtitleLabel(
      title: "How much do you want to spend at",
      merchantName: " \(merchantName)?"
    )
    let secondSubtitleLabel = SubtitleLabel(title: "You'll only be charged for what you end up spending")
    let divider = DividerView()

    currencyLabel.font = amountField.font
    currencyLabel.textColor = amountField.textColor

    continueButton.addTarget(inputViewController, action: continueAction, for: .touchUpInside)

    horizontalStackView.addArrangedSubview(currencyLabel)
    horizontalStackView.addArrangedSubview(amountField)

    addSubview(titleLabel)
    addSubview(firstSubtitleLabel)
    addSubview(enterAmountContainerView)
    addSubview(secondSubtitleLabel)
    addSubview(horizontalStackView)
    addSubview(noteLabel)
    addSubview(divider)
    addSubview(continueButton)

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      firstSubtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      firstSubtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      firstSubtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      secondSubtitleLabel.topAnchor.constraint(equalTo: firstSubtitleLabel.bottomAnchor, constant: 4),
      secondSubtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      secondSubtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      enterAmountContainerView.topAnchor.constraint(equalTo: secondSubtitleLabel.bottomAnchor, constant: 24),
      enterAmountContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      enterAmountContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      horizontalStackView.topAnchor.constraint(equalTo: enterAmountContainerView.topAnchor, constant: 32),
      horizontalStackView.leadingAnchor.constraint(equalTo: enterAmountContainerView.leadingAnchor, constant: 16),
      horizontalStackView.trailingAnchor.constraint(
        lessThanOrEqualTo: enterAmountContainerView.trailingAnchor,
        constant: -16
      ),

      noteLabel.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 8),
      noteLabel.leadingAnchor.constraint(equalTo: enterAmountContainerView.leadingAnchor, constant: 16),
      noteLabel.trailingAnchor.constraint(lessThanOrEqualTo: enterAmountContainerView.trailingAnchor, constant: -16),

      divider.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 16),
      divider.leadingAnchor.constraint(equalTo: enterAmountContainerView.leadingAnchor, constant: 16),
      divider.trailingAnchor.constraint(equalTo: enterAmountContainerView.trailingAnchor, constant: -16),

      continueButton.leadingAnchor.constraint(equalTo: enterAmountContainerView.leadingAnchor, constant: 16),
      continueButton.trailingAnchor.constraint(equalTo: enterAmountContainerView.trailingAnchor, constant: -16),
      continueButton.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 16),
      continueButton.bottomAnchor.constraint(equalTo: enterAmountContainerView.bottomAnchor, constant: -32),
      continueButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
    ])

    let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    addGestureRecognizer(tap)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
