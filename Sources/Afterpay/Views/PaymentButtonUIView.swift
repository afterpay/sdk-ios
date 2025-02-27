//
//  PaymentButtonUIView.swift
//  Afterpay
//
//  Created by Scott Antonac on 16/2/22.
//  Copyright © 2022 Afterpay. All rights reserved.
//

import Foundation
import UIKit

public final class PaymentButtonUIView: LayeredImageView {
  internal var minimumWidth: CGFloat = 256

  public var buttonKind: ButtonKind = .buyNow {
    didSet { setForeground() }
  }

  override internal func sharedInit() {
    super.sharedInit()

    imageLayers.background = "button-background"
    setForeground()
  }

  override internal func setForeground() {
    /// There is an additional type of foreground asset where we don't apply a tint.
    /// Since the ultimate resolution of the tint and kind aren't resolved until updateImages()
    /// in LayeredImageView, we pass both foreground asset types forward
    polyChromeImageLayer = buttonKind.polyForegroundString
    imageLayers.foreground = buttonKind.foregroundString
  }
}

public enum ButtonKind {
  case buyNow
  case checkout
  case payNow
  case placeOrder

  var foregroundString: String {
    switch self {
    case .buyNow:
      return Afterpay.drawable.localized.buttonBuyNowForeground
    case .checkout:
      return Afterpay.drawable.localized.buttonCheckoutForeground
    case .payNow:
      return Afterpay.drawable.localized.buttonPayNowForeground
    case .placeOrder:
      return Afterpay.drawable.localized.buttonPlaceOrderForeground
    }
  }

  var polyForegroundString: String {
    switch self {
    case .buyNow:
      return Afterpay.drawable.polyLocalized.buttonBuyNowForeground
    case .checkout:
      return Afterpay.drawable.polyLocalized.buttonCheckoutForeground
    case .payNow:
      return Afterpay.drawable.polyLocalized.buttonPayNowForeground
    case .placeOrder:
      return Afterpay.drawable.polyLocalized.buttonPlaceOrderForeground
    }
  }

  var accessibilityLabel: String {
    switch self {
    case .buyNow:
      return "buy now with"
    case .checkout:
      return "checkout with"
    case .payNow:
      return "pay now with"
    case .placeOrder:
      return "place order with"
    }
  }
}
