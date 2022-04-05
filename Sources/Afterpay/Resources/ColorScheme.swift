//
//  BadgeStyle.swift
//  Afterpay
//
//  Created by Adam Campbell on 5/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

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

  var uiColors: (foreground: UIColor?, background: UIColor?) {
    switch self {
    case .blackOnMint:
      return (
        foreground: UIColor.black,
        background: UIColor(named: "BondiMint", in: Afterpay.bundle, compatibleWith: nil)!
      )
    case .mintOnBlack:
      return (
        foreground: UIColor(named: "BondiMint", in: Afterpay.bundle, compatibleWith: nil)!,
        background: UIColor.black
      )
    case .whiteOnBlack:
      return (
        foreground: UIColor.white,
        background: UIColor.black
      )
    case .blackOnWhite:
      return (
        foreground: UIColor.black,
        background: UIColor.white
      )
    }
  }

  var slug: String {
    switch self {
    case .blackOnMint:
      return "black-on-mint"
    case .mintOnBlack:
      return "mint-on-black"
    case .whiteOnBlack:
      return "white-on-black"
    case .blackOnWhite:
      return "black-on-white"
    }
  }

  var foreground: String {
    switch self {
    case .blackOnMint:
      return "black"
    case .mintOnBlack:
      return "mint"
    case .whiteOnBlack:
      return "white"
    case .blackOnWhite:
      return "black"
    }
  }
}
