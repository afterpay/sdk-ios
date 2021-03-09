//
//  ConsumerCardDisplayView.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 17/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class ConsumerCardDisplayView: UIView {

  private let topRightLabel: UILabel = {
    let label = UILabel()
    label.text = "Limited Use\nVirtual"
    label.numberOfLines = 2
    label.textAlignment = .right

    let textFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: textFont)
    label.textColor = UIColor.consumerCardDescriptionTextColor

    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true
    return label
  }()

  private let onlineShoppingLabel: UILabel = {
    let label = UILabel()
    label.text = "Online Shopping"
    label.numberOfLines = 0

    let textFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: textFont)
    label.textColor = UIColor.consumerCardDescriptionTextColor

    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true
    return label
  }()

  private let afterpayLogo: LogoView = {
    let logoView = LogoView(colorScheme: .static(.mintOnBlack))

    logoView.translatesAutoresizingMaskIntoConstraints = false
    return logoView
  }()

  private let horizontalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 24

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let fourDigitsLabel: (_ fourDigits: String) -> UILabel = { fourDigits in
    let label = UILabel()
    label.text = fourDigits
    label.numberOfLines = 1

    let textFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: textFont)
    label.textColor = UIColor.consumerCardTextColor

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }

  private let expiryLabel: (_ text: String) -> UILabel = { text in
    let label = UILabel()
    label.text = text
    label.numberOfLines = 1

    let textFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: textFont)
    label.textColor = UIColor.consumerCardTextColor

    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true

    return label
  }

  private var lastFourDigitsLabel = UILabel()
  private var expiryDateLabel = UILabel()

  init(lastFourDigits: String, expiryDate: String) {
    super.init(frame: .zero)

    backgroundColor = .black

    for _ in 0...2 {
      horizontalStackView.addArrangedSubview(fourDigitsLabel("****"))
    }

    lastFourDigitsLabel = fourDigitsLabel(lastFourDigits)
    lastFourDigitsLabel.adjustsFontForContentSizeCategory = true
    horizontalStackView.addArrangedSubview(lastFourDigitsLabel)

    let expiryTitleLabel = expiryLabel("Expiry")
    expiryDateLabel = expiryLabel(expiryDate)

    addSubview(afterpayLogo)
    addSubview(topRightLabel)
    addSubview(onlineShoppingLabel)
    addSubview(horizontalStackView)
    addSubview(expiryTitleLabel)
    addSubview(expiryDateLabel)

    layer.cornerRadius = 12

    NSLayoutConstraint.activate([
      topRightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
      topRightLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),

      afterpayLogo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
      afterpayLogo.topAnchor.constraint(equalTo: topAnchor, constant: 24),

      onlineShoppingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
      onlineShoppingLabel.topAnchor.constraint(greaterThanOrEqualTo: afterpayLogo.bottomAnchor, constant: 24),
      onlineShoppingLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: 24),

      horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
      horizontalStackView.topAnchor.constraint(equalTo: onlineShoppingLabel.bottomAnchor, constant: 24),
      horizontalStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: 24),

      expiryTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
      expiryTitleLabel.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 24),
      expiryTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: 24),

      expiryDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
      expiryDateLabel.topAnchor.constraint(equalTo: expiryTitleLabel.bottomAnchor),
      expiryDateLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: 24),
      expiryDateLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16),
    ])
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  func updateCardDetails(lastFourDigits: String, expiryDate: String) {
    lastFourDigitsLabel.text = lastFourDigits
    expiryDateLabel.text = expiryDate
  }

}
