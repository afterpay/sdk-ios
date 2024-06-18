//
//  CheckoutOptionsCell.swift
//  Example
//
//  Created by Huw Rowlands on 4/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Afterpay
import Foundation
import UIKit

final class CheckoutOptionsCell: UITableViewCell {

  let expressLabel = UILabel()
  let expressSwitch = UISwitch()
  let checkoutOptionsTitle = UILabel()
  let buyNowLabel = UILabel()
  let buyNowSwitch = UISwitch()
  let pickupLabel = UILabel()
  let pickupSwitch = UISwitch()
  let shippingOptionRequiredLabel = UILabel()
  let shippingOptionRequiredSwitch = UISwitch()

  private lazy var buyNowStack = UIStackView(arrangedSubviews: [buyNowLabel, buyNowSwitch])
  private lazy var pickupStack = UIStackView(arrangedSubviews: [pickupLabel, pickupSwitch])
  private lazy var shippingStack = UIStackView(
    arrangedSubviews: [shippingOptionRequiredLabel, shippingOptionRequiredSwitch]
  )

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    expressLabel.text = "Express checkout"
    expressLabel.font = .preferredFont(forTextStyle: .headline)
    expressSwitch.addTarget(self, action: #selector(expressToggled), for: .valueChanged)

    checkoutOptionsTitle.font = .preferredFont(forTextStyle: .headline)
    checkoutOptionsTitle.text = "Express checkout options"

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
        checkoutOptionsTitle,
        buyNowStack,
        pickupStack,
        shippingStack,
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

    case expressEnabled(Bool)
  }

  func configureForV3(buyNow: Bool?, eventHandler: ((Event) -> Void)? = nil) {
    [checkoutOptionsTitle, pickupStack, shippingStack].forEach { $0.isHidden = true }
    buyNowStack.isHidden = false
    buyNowSwitch.isOn = buyNow == true
    self.eventHandler = eventHandler
  }

  func configure(options: CheckoutV2Options, expressCheckout: Bool, eventHandler: ((Event) -> Void)? = nil) {
    [checkoutOptionsTitle, buyNowStack, pickupStack, shippingStack].forEach { $0.isHidden = false }

    expressSwitch.isOn = expressCheckout
    configureCheckoutV2Options(enabled: expressCheckout)

    buyNowSwitch.isOn = options.buyNow ?? false
    pickupSwitch.isOn = options.pickup ?? false
    shippingOptionRequiredSwitch.isOn = options.shippingOptionRequired ?? true

    self.eventHandler = eventHandler
  }

  private func configureCheckoutV2Options(enabled: Bool) {
    [buyNowSwitch, pickupSwitch, shippingOptionRequiredSwitch].forEach { $0.isEnabled = enabled }
    [checkoutOptionsTitle, buyNowLabel, pickupLabel, shippingOptionRequiredLabel].forEach { $0.isEnabled = enabled }
  }

  private var eventHandler: ((Event) -> Void)?

  @objc public func expressToggled() {
    eventHandler?(.expressEnabled(expressSwitch.isOn))
    configureCheckoutV2Options(enabled: expressSwitch.isOn)
  }

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
