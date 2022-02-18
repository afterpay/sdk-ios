//
//  PaymentButton.swift
//  Afterpay
//
//  Created by Adam Campbell on 27/11/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

public final class PaymentButton: UIButton {

  private var paymentButtonView: PaymentButtonUIView = PaymentButtonUIView()

  public var colorScheme: ColorScheme = .static(.blackOnMint) {
    didSet { paymentButtonView.colorScheme = colorScheme }
  }

  public var buttonKind: ButtonKind = .buyNow {
    didSet { print("change button kind") } // TODO: change button kind
  }

  public init(colorScheme: ColorScheme = .static(.blackOnMint), buttonKind: ButtonKind = .payNow) {
    self.colorScheme = colorScheme
    self.buttonKind = buttonKind
    self.paymentButtonView = PaymentButtonUIView(colorScheme: colorScheme)

    super.init(frame: .zero)

    sharedInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    sharedInit()
  }

  private func sharedInit() {
    translatesAutoresizingMaskIntoConstraints = false
    adjustsImageWhenHighlighted = true
    adjustsImageWhenDisabled = true

    addSubview(paymentButtonView)
    paymentButtonView.translatesAutoresizingMaskIntoConstraints = false
    paymentButtonView.isUserInteractionEnabled = false

    if paymentButtonView.ratio != nil {
      NSLayoutConstraint.activate([
        heightAnchor.constraint(equalTo: widthAnchor, multiplier: paymentButtonView.ratio!),
        widthAnchor.constraint(greaterThanOrEqualToConstant: 256),
        paymentButtonView.widthAnchor.constraint(equalTo: widthAnchor),
      ])
    }
  }

  public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    paymentButtonView.updateColors(withTraits: traitCollection)
  }
}
