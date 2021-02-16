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

  var verticalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 8
    return stackView
  }()

  let headlineLabel: (_ text: String) -> UILabel = { text in
    let label = UILabel()
    label.text = text
    label.textAlignment = .left

    let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: font)

    label.adjustsFontForContentSizeCategory = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }

  init(continueAction: Selector) {
    super.init(frame: .zero)

    let continueButton = PrimaryButton(title: "Continue with")
    continueButton.addTarget(inputViewController, action: continueAction, for: .touchUpInside)

    let titleLabel = TitleLabel(with: "Lorem Ipsum\nLorem Ipsum")

    let firstHeadline = headlineLabel("first headline")
    let secondHeadline = headlineLabel("second headline")
    let thirdHeadline = headlineLabel("third headline")

    verticalStackView.addArrangedSubview(firstHeadline)
    verticalStackView.addArrangedSubview(secondHeadline)
    verticalStackView.addArrangedSubview(thirdHeadline)

    addSubview(continueButton)
    addSubview(titleLabel)
    addSubview(verticalStackView)

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      verticalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),

      continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      continueButton.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 24),
      continueButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
    ])
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
