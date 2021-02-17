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

  private let virtualCardDisplayView = VirtualCardDisplayView(lastFourDigits: "", expiryDate: "")

  private let lastFourDigits: (_ cardNumber: String) -> String = { cardNumber in
    return String(cardNumber.suffix(4))
  }

  init(virtualCard: VirtualCard, expiry: String, continueAction: Selector) {
    super.init(frame: .zero)

    let titleLabel = TitleLabel(with: "$123", fontSize: 56)
    let subtitleLabel = SubtitleLabel(with: "Lorem ipsum dolor", fontSize: 16)
    let continueButton = PrimaryButton(title: "Continue to finalise your order")

    virtualCardDisplayView.translatesAutoresizingMaskIntoConstraints = false

    // Add target for continue button
    continueButton.addTarget(inputViewController, action: continueAction, for: .touchUpInside)

    updateCardDetails(with: virtualCard, expiry: expiry)

    addSubview(titleLabel)
    addSubview(subtitleLabel)
    addSubview(continueButton)
    addSubview(virtualCardDisplayView)

    // Adjust constraint
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      virtualCardDisplayView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
      virtualCardDisplayView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      virtualCardDisplayView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      virtualCardDisplayView.heightAnchor.constraint(equalToConstant: 216),

      continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      continueButton.topAnchor.constraint(equalTo: virtualCardDisplayView.bottomAnchor, constant: 24),
      continueButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateCardDetails(with virtualCard: VirtualCard, expiry: String) {
    virtualCardDisplayView.updateCardDetails(lastFourDigits: lastFourDigits(virtualCard.cardNumber), expiryDate: virtualCard.expiry)
  }
}
