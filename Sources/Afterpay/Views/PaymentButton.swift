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

  internal var paymentButtonView: PaymentButtonUIView = PaymentButtonUIView()

  public var colorScheme: ColorScheme = .static(.default) {
    didSet { paymentButtonView.colorScheme = colorScheme }
  }

  public var buttonKind: ButtonKind = .buyNow {
    didSet { updatePaymentButtonView() }
  }

  public init(colorScheme: ColorScheme = .static(.default), buttonKind: ButtonKind = .buyNow) {
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
    updatePaymentButtonView()

    if paymentButtonView.ratio != nil {
      NSLayoutConstraint.activate([
        heightAnchor.constraint(equalTo: widthAnchor, multiplier: paymentButtonView.ratio!),
        widthAnchor.constraint(greaterThanOrEqualToConstant: paymentButtonView.minimumWidth),
        paymentButtonView.widthAnchor.constraint(equalTo: widthAnchor),
      ])
    }

    let selector = #selector(configurationDidChange)
    let name: NSNotification.Name = .configurationUpdated
    notificationCenter.addObserver(self, selector: selector, name: name, object: nil)
  }

  private func updatePaymentButtonView() {
    paymentButtonView.buttonKind = buttonKind
    accessibilityLabel = "\(buttonKind.accessibilityLabel) \(Afterpay.brand.details.accessibleName)"
  }

  public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    paymentButtonView.updateColors(withTraits: traitCollection)
  }

  @objc private func configurationDidChange(_ notification: NSNotification) {
    DispatchQueue.main.async {
      self.updatePaymentButtonView()
      self.paymentButtonView.setForeground()
    }
  }
}
