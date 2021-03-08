//
//  CheckoutOptionsCell.swift
//  Example
//
//  Created by Huw Rowlands on 4/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Afterpay
import Foundation

final class CheckoutOptionsCell: UITableViewCell {

  let buyNowLabel = UILabel()
  let buyNowSwitch = UISwitch()

  let pickupLabel = UILabel()
  let pickupSwitch = UISwitch()

  let shippingOptionRequiredLabel = UILabel()
  let shippingOptionRequiredSwitch = UISwitch()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    let title = UILabel()
    title.font = .preferredFont(forTextStyle: .headline)
    title.text = "Checkout options"

    buyNowLabel.text = "Buy now"
    buyNowSwitch.addTarget(self, action: #selector(buyNowToggled), for: .valueChanged)

    pickupLabel.text = "Pickup"
    pickupSwitch.addTarget(self, action: #selector(pickupToggled), for: .valueChanged)

    shippingOptionRequiredLabel.text = "Shipping option required"
    shippingOptionRequiredSwitch.addTarget(
      self, action: #selector(shippingOptionRequiredToggled), for: .valueChanged
    )

    let verticalStack = UIStackView(
      arrangedSubviews: [
        title,
        UIStackView(arrangedSubviews: [buyNowLabel, buyNowSwitch]),
        UIStackView(arrangedSubviews: [pickupLabel, pickupSwitch]),
        UIStackView(arrangedSubviews: [shippingOptionRequiredLabel, shippingOptionRequiredSwitch]),
      ]
    )

    verticalStack.axis = .vertical
    verticalStack.spacing = 8
    verticalStack.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(verticalStack)

    let layoutGuide = contentView.readableContentGuide

    NSLayoutConstraint.activate([
      verticalStack.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
      verticalStack.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
      verticalStack.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
      verticalStack.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
    ])
  }

  private static func makeStack(title: String, target: CheckoutOptionsCell, toggleAction: Selector) -> UIStackView {
    let label = UILabel()
    label.text = title

    let switchControl = UISwitch()
    switchControl.isOn = false
    switchControl.addTarget(target, action: toggleAction, for: .valueChanged)

    return UIStackView(arrangedSubviews: [label, switchControl])
  }

  // MARK: Actions

  enum Event {
    case buyNow
    case pickup
    case shippingOptionRequired
  }

  func configure(initialOptions: CheckoutV2Options, eventHandler: ((Event) -> Void)? = nil) {
    buyNowSwitch.isOn = initialOptions.buyNow ?? false
    pickupSwitch.isOn = initialOptions.pickup ?? false
    shippingOptionRequiredSwitch.isOn = initialOptions.shippingOptionRequired ?? true

    self.eventHandler = eventHandler
  }

  private var eventHandler: ((Event) -> Void)?

  @objc public func buyNowToggled() {
    eventHandler?(.buyNow)
  }

  @objc public func pickupToggled() {
    eventHandler?(.pickup)
  }

  @objc public func shippingOptionRequiredToggled() {
    eventHandler?(.shippingOptionRequired)
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
