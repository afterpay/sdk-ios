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
  private let virtualCardExpiryLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.textAlignment = .left

    let textFont = UIFont.systemFont(ofSize: 14, weight: .thin)
    label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: textFont)
    label.textColor = .black

    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true
    return label
  }()

  private var titleLabel: TitleLabel = TitleLabel(with: "", fontSize: 56)

  private let lastFourDigits: (_ cardNumber: String) -> String = { cardNumber in
    return String(cardNumber.suffix(4))
  }
  
  private var virtualCardExpiryView: UIStackView = {
    let stackView = UIStackView()
    let iconView = SVGView(svgConfiguration: ClockIconSVGConfiguration(colorScheme: .static(.blackOnWhite)))

    stackView.axis = .horizontal
    stackView.spacing = 8

    stackView.addArrangedSubview(iconView)

    iconView.translatesAutoresizingMaskIntoConstraints = false
    stackView.translatesAutoresizingMaskIntoConstraints = false
 
    NSLayoutConstraint.activate([
      iconView.heightAnchor.constraint(equalToConstant: 16),
      iconView.widthAnchor.constraint(equalToConstant: 16),
    ])
  
    return stackView
  }()

  init(continueAction: Selector, merchantName: String) {
    super.init(frame: .zero)

    let subtitleLabel = SubtitleLabel(title: "Ready to use at ", merchantName: merchantName, fontSize: 16)
    let continueButton = PrimaryButton(title: "Continue to finalise your order")

    virtualCardDisplayView.translatesAutoresizingMaskIntoConstraints = false

    // Add target for continue button
    continueButton.addTarget(inputViewController, action: continueAction, for: .touchUpInside)
    
    virtualCardExpiryView.addArrangedSubview(virtualCardExpiryLabel)

    addSubview(titleLabel)
    addSubview(subtitleLabel)
    addSubview(continueButton)
    addSubview(virtualCardDisplayView)
    addSubview(virtualCardExpiryView)

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

      virtualCardExpiryView.topAnchor.constraint(equalTo: virtualCardDisplayView.bottomAnchor, constant: 24),
      virtualCardExpiryView.centerXAnchor.constraint(equalTo: centerXAnchor),
      virtualCardExpiryView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
      virtualCardExpiryView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),

      continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      continueButton.topAnchor.constraint(greaterThanOrEqualTo: virtualCardExpiryView.bottomAnchor, constant: 24),
      continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -64),
      continueButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateCardDetails(with amount: Money, virtualCard: VirtualCard, expiry: String) {
    virtualCardDisplayView.updateCardDetails(lastFourDigits: lastFourDigits(virtualCard.cardNumber), expiryDate: virtualCard.expiry)
    virtualCardExpiryLabel.text = "This card is valid until \(expiry.convertToLocalTime())"
    titleLabel.text = "$\(amount.amount)"
  }
}

extension String {
  func convertToLocalTime() -> Self {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

    guard let date = dateFormatter.date(from: self) else {
      return self
    }

    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "MMM d, yyyy h:mm a"

    return dateFormatter.string(from: date)
  }
}
