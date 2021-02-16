//
//  EnterAmountView.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 9/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import UIKit

final class EnterAmountView: UIView {

  var amountField: UITextField = {
    let field = UITextField()
    field.keyboardType = .numberPad
    field.textColor = .black
    field.font = UIFont.boldSystemFont(ofSize: 56)
    return field
  }()

  init(continueAction: Selector) {
    super.init(frame: .zero)

    let continueButton = PrimaryButton(title: "Continue")
    let titleLabel = TitleLabel(with: "Lorem Ipsum")

    continueButton.addTarget(inputViewController, action: continueAction, for: .touchUpInside)

    amountField.translatesAutoresizingMaskIntoConstraints = false

    addSubview(amountField)
    addSubview(continueButton)
    addSubview(titleLabel)

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      amountField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
      amountField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      amountField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      continueButton.topAnchor.constraint(equalTo: amountField.bottomAnchor, constant: 24),
      continueButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
    ])

    let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    addGestureRecognizer(tap)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
