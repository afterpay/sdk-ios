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

  init(cardNumber: String) {
    self.cardNumberLabel = UILabel()

    super.init(frame: .zero)

    self.cardNumberLabel.text = cardNumber

    cardNumberLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(cardNumberLabel)

    // Adjust constraint
    NSLayoutConstraint.activate([
      cardNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      cardNumberLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      cardNumberLabel.topAnchor.constraint(equalTo: topAnchor),
      cardNumberLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateCardNumber(with cardNumber: String) {
    cardNumberLabel.text = "Card number: \(cardNumber)"
  }
}
