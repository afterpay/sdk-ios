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
    return field
  }()

  private var verticalStack: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    stackView.spacing = 8
    return stackView
  }()

  init(continueAction: Selector) {
    super.init(frame: .zero)

    let continueButton = UIButton()
    continueButton.setTitle("Submit and Continue", for: .normal)
    continueButton.setTitleColor(.blue, for: .normal)
    continueButton.addTarget(inputViewController, action: continueAction, for: .touchDown)

    verticalStack.addArrangedSubview(amountField)
    verticalStack.addArrangedSubview(continueButton)

    amountField.translatesAutoresizingMaskIntoConstraints = false
    continueButton.translatesAutoresizingMaskIntoConstraints = false
    verticalStack.translatesAutoresizingMaskIntoConstraints = false

    addSubview(verticalStack)

    NSLayoutConstraint.activate([
      verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      verticalStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
    ])
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
