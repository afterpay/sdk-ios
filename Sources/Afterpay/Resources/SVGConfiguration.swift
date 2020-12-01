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
    let svgForPalette: (ColorPalette) -> SVG = { palette in
      switch (palette, locale) {
      case (.blackOnMint, Locales.greatBritain):
        return .clearpayBadgeBlackOnMint
      case (.mintOnBlack, Locales.greatBritain):
        return .clearpayBadgeMintOnBlack
      case (.whiteOnBlack, Locales.greatBritain):
        return .clearpayBadgeWhiteOnBlack
      case (.blackOnWhite, Locales.greatBritain):
        return .clearpayBadgeBlackOnWhite
      case (.blackOnMint, _):
        return .afterpayBadgeBlackOnMint
      case (.mintOnBlack, _):
        return .afterpayBadgeMintOnBlack
      case (.whiteOnBlack, _):
        return .afterpayBadgeWhiteOnBlack
      case (.blackOnWhite, _):
        return .afterpayBadgeBlackOnWhite
      }
    }

    let svg: SVG = {
      switch traitCollection.userInterfaceStyle {
      case .dark:
        return svgForPalette(colorScheme.darkPalette)
      case .light, .unspecified:
        fallthrough
      @unknown default:
        return svgForPalette(colorScheme.lightPalette)
      }
    }()

    return svg
  }

  func accessibilityLabel(localizedFor locale: Locale) -> String {
    locale == Locales.greatBritain ? Strings.accessibleClearpay : Strings.accessibleAfterpay
  }

}

struct PaymentButtonConfiguration: SVGConfiguration {

  var colorScheme: ColorScheme

  func svg(localizedFor locale: Locale, withTraits traitCollection: UITraitCollection) -> SVG {
    let svgForPalette: (ColorPalette) -> SVG = { palette in
      switch (palette, locale) {
      case (.blackOnMint, Locales.greatBritain):
        return .clearpayPayNowBlackOnMint
      case (.mintOnBlack, Locales.greatBritain):
        return .clearpayPayNowMintOnBlack
      case (.whiteOnBlack, Locales.greatBritain):
        return .clearpayPayNowWhiteOnBlack
      case (.blackOnWhite, Locales.greatBritain):
        return .clearpayPayNowBlackOnWhite
      case (.blackOnMint, _):
        return .afterpayPayNowBlackOnMint
      case (.mintOnBlack, _):
        return .afterpayPayNowMintOnBlack
      case (.whiteOnBlack, _):
        return .afterpayPayNowWhiteOnBlack
      case (.blackOnWhite, _):
        return .afterpayPayNowBlackOnWhite
      }
    }

    let svg: SVG = {
      switch traitCollection.userInterfaceStyle {
      case .dark:
        return svgForPalette(colorScheme.darkPalette)
      case .light, .unspecified:
        fallthrough
      @unknown default:
        return svgForPalette(colorScheme.lightPalette)
      }
    }()

    return svg
  }

  func accessibilityLabel(localizedFor locale: Locale) -> String {
    let accessiblePaymentMethod = locale == Locales.greatBritain
      ? Strings.accessibleClearpay
      : Strings.accessibleAfterpay

    return "\(Strings.payNowWith) \(accessiblePaymentMethod)"
  }

}
