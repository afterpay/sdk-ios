//
//  SVGConfiguration.swift
//  Afterpay
//
//  Created by Adam Campbell on 13/10/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

protocol SVGConfiguration {

  var colorScheme: ColorScheme { get set }

  func svg(localizedFor locale: Locale, withTraits traitCollection: UITraitCollection) -> SVG
  func accessibilityLabel(localizedFor locale: Locale) -> String

}

struct BadgeConfiguration: SVGConfiguration {

  var colorScheme: ColorScheme = .static(.blackOnMint)

  func svg(localizedFor locale: Locale, withTraits traitCollection: UITraitCollection) -> SVG {
    switch traitCollection.userInterfaceStyle {
    case .dark:
      return SVG.badge(palette: colorScheme.darkPalette, locale: locale)
    case .light, .unspecified:
      fallthrough
    @unknown default:
      return SVG.badge(palette: colorScheme.lightPalette, locale: locale)
    }
  }

  func accessibilityLabel(localizedFor locale: Locale) -> String {
    locale == Locales.greatBritain ? Strings.accessibleClearpay : Strings.accessibleAfterpay
  }

}

struct PaymentButtonConfiguration: SVGConfiguration {

  var colorScheme: ColorScheme
  var buttonKind: ButtonKind

  private func svg(for palette: ColorPalette, locale: Locale) -> SVG {
    let svg: (ColorPalette, Locale) -> SVG

    switch buttonKind {
    case .buyNow:
      svg = SVG.buyNow(palette:locale:)
    case .checkout:
      svg = SVG.checkout(palette:locale:)
    case .payNow:
      svg = SVG.payNow(palette:locale:)
    case .placeOrder:
      svg = SVG.placeOrder(palette:locale:)
    }

    return svg(palette, locale)
  }

  func svg(localizedFor locale: Locale, withTraits traitCollection: UITraitCollection) -> SVG {
    switch traitCollection.userInterfaceStyle {
    case .dark:
      return svg(for: colorScheme.darkPalette, locale: locale)
    case .light, .unspecified:
      fallthrough
    @unknown default:
      return svg(for: colorScheme.lightPalette, locale: locale)
    }
  }

  func accessibilityLabel(localizedFor locale: Locale) -> String {
    let accessiblePaymentMethod = locale == Locales.greatBritain
      ? Strings.accessibleClearpay
      : Strings.accessibleAfterpay

    return "\(buttonKind.accessibilityLabel) \(accessiblePaymentMethod)"
  }

}
