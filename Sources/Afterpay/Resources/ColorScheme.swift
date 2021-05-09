//
//  BadgeStyle.swift
//  Afterpay
//
//  Created by Adam Campbell on 5/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

public enum ColorScheme {
  case `static`(ColorPalette)
  case dynamic(lightPalette: ColorPalette, darkPalette: ColorPalette)

  var lightPalette: ColorPalette {
    switch self {
    case .static(let palette):
      return palette
    case .dynamic(let lightPalette, _):
      return lightPalette
    }
  }

  var darkPalette: ColorPalette {
    switch self {
    case .static(let palette):
      return palette
    case .dynamic(_, let darkPalette):
      return darkPalette
    }
  }

}

public enum ColorPalette {
  case blackOnMint
  case mintOnBlack
  case whiteOnBlack
  case blackOnWhite
}

public enum ButtonKind {
  case buyNow
  case checkout
  case payNow
  case placeOrder

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
