//
//  ConsumerCardView.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 12/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class ConsumerCardView: UIView {
  private let cardNumberLabel: UILabel

  init(virtualCard: VirtualCard, expiry: String, continueAction: Selector) {
    self.cardNumberLabel = UILabel()

    super.init(frame: .zero)

    let titleLabel = TitleLabel(with: "$123", fontSize: 56)
    let subtitleLabel = SubtitleLabel(with: "Lorem ipsum dolor", fontSize: 16)
    let continueButton = PrimaryButton(title: "Continue to finalise your order")

    self.cardNumberLabel.text = virtualCard.cardNumber

    // Add target for continue button
    continueButton.addTarget(inputViewController, action: continueAction, for: .touchUpInside)

    cardNumberLabel.translatesAutoresizingMaskIntoConstraints = false

    addSubview(titleLabel)
    addSubview(subtitleLabel)
    addSubview(continueButton)
    addSubview(cardNumberLabel)

    // Adjust constraint
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      cardNumberLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
      cardNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      cardNumberLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),

      continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      continueButton.topAnchor.constraint(equalTo: cardNumberLabel.bottomAnchor, constant: 24),
      continueButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateCardNumber(with cardNumber: String) {
    cardNumberLabel.text = "Card number: \(cardNumber)"
  }
}
