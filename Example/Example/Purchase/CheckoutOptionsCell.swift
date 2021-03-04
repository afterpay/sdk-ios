//
//  CheckoutOptionsCell.swift
//  Example
//
//  Created by Huw Rowlands on 4/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

final class CheckoutOptionsCell: UITableViewCell {

  private let buyNowLabel = UILabel()
  private let buyNowSwitch = UISwitch()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    buyNowLabel.text = "Buy now"
    buyNowSwitch.isOn = false
    buyNowSwitch.addTarget(self, action: #selector(buyNowToggled), for: .valueChanged)

    let buyNowStack = UIStackView(
      arrangedSubviews: [buyNowLabel, buyNowSwitch]
    )

    buyNowStack.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(buyNowStack)

    let layoutGuide = contentView.readableContentGuide

    NSLayoutConstraint.activate([
      buyNowStack.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
      buyNowStack.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
      buyNowStack.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
      buyNowStack.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
    ])
  }

  func configure(eventHandler: ((Bool) -> Void)? = nil) {
    self.eventHandler = eventHandler
  }

  var eventHandler: ((Bool) -> Void)?

  @objc private func buyNowToggled() {
    eventHandler?(buyNowSwitch.isOn)
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
