//
//  WelcomeView.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 9/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class WelcomeView: UIView {

  init(continueAction: Selector) {
    super.init(frame: .zero)

    let continueButton = PrimaryButton(title: "Continue with")
    continueButton.addTarget(inputViewController, action: continueAction, for: .touchUpInside)

    let titleLabel = TitleLabel(with: "Lorem Ipsum\nLorem Ipsum")

    continueButton.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    addSubview(continueButton)
    addSubview(titleLabel)

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      continueButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
      continueButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
    ])
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
