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
  case `default`
  case alt
  case darkMono
  case lightMono

  var requiresPolychrome: Bool {
    switch self {
    case .default: return true
    default: return false
    }
  }

  var uiColorsCashAppAfterpay: (foreground: UIColor?, background: UIColor?) {
    switch self {
    case .alt:
      return (
        foreground: UIColor.black,
        background: AfterpayAssetProvider.color(named: "CashGreen")
      )
    case .default:
      return (
        foreground: UIColor.clear,
        background: UIColor.black
      )
    case .darkMono:
      return (
        foreground: UIColor.white,
        background: UIColor.black
      )
    case .lightMono:
      return (
        foreground: UIColor.black,
        background: UIColor.white
      )
    }
  }

  var uiColors: (foreground: UIColor?, background: UIColor?) {
    switch self {
    case .alt:
      return (
        foreground: UIColor.black,
        background: AfterpayAssetProvider.color(named: "BondiMint")
      )
    case .default:
      return (
        foreground: AfterpayAssetProvider.color(named: "BondiMint"),
        background: UIColor.black
      )
    case .darkMono:
      return (
        foreground: UIColor.white,
        background: UIColor.black
      )
    case .lightMono:
      return (
        foreground: UIColor.black,
        background: UIColor.white
      )
    }
  }

  var slugCashAppAfterpay: String {
    switch self {
    case .alt:
      return "alt"
    case .default:
      return "preferred"
    case .darkMono:
      return "darkMono"
    case .lightMono:
      return "lightMono"
    }
  }

  var slug: String {
    switch self {
    case .alt:
      return "black-on-mint"
    case .default:
      return "mint-on-black"
    case .darkMono:
      return "white-on-black"
    case .lightMono:
      return "black-on-white"
    }
  }
  var foregroundCashAppAfterpay: String {
    switch self {
    case .alt:
      return "alt"
    case .default:
      return "preferred"
    case .darkMono:
      return "darkMono"
    case .lightMono:
      return "lightMono"
    }
  }

  var foreground: String {
    switch self {
    case .alt:
      return "black"
    case .default:
      return "mint"
    case .darkMono:
      return "white"
    case .lightMono:
      return "black"
    }
  }
}
