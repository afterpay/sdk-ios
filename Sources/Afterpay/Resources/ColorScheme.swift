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
        background: AfterpayAssetProvider.color(named: "BondiMint")
      )
    case .mintOnBlack:
      return (
        foreground: AfterpayAssetProvider.color(named: "BondiMint"),
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
}
