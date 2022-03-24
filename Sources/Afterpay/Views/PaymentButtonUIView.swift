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
    let brand = getLocale() == Locales.greatBritain ? "clearpay" : "afterpay"
    imageLayers.foreground = "button-foreground-\(buttonKind.slug)-\(brand)"
  }
}

public enum ButtonKind {
  case buyNow
  case checkout
  case payNow
  case placeOrder

  var slug: String {
    switch self {
    case .buyNow:
      return "buy-now"
    case .checkout:
      return "checkout"
    case .payNow:
      return "pay-now"
    case .placeOrder:
      return "place-order"
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
