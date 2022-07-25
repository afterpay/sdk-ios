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
      return Afterpay.drawable.localised.buttonBuyNowForeground
    case .checkout:
      return Afterpay.drawable.localised.buttonCheckoutForeground
    case .payNow:
      return Afterpay.drawable.localised.buttonPayNowForeground
    case .placeOrder:
      return Afterpay.drawable.localised.buttonPlaceOrderForeground
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
