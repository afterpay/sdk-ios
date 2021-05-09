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
  var buttonKind: ButtonKind

  // swiftlint:disable:next cyclomatic_complexity
  private func svg(for palette: ColorPalette, locale: Locale) -> SVG {
    switch (palette, buttonKind, locale) {

    //BUY NOW WITH AFTERPAY
    case (.whiteOnBlack, .buyNow, Locales.greatBritain),
      (.mintOnBlack, .buyNow, Locales.greatBritain):
      return .clearpayBuyNowWhiteOnBlack
    case (.blackOnMint, .buyNow, Locales.greatBritain),
      (.blackOnWhite, .buyNow, Locales.greatBritain):
      return .clearpayBuyNowBlackOnMint

    case (.mintOnBlack, .buyNow, _),
      (.whiteOnBlack, .buyNow, _):
      return .afterpayBuyNowWhiteOnBlack
    case (.blackOnMint, .buyNow, _),
      (.blackOnWhite, .buyNow, _):
      return .afterpayBuyNowBlackOnMint

    //CHECKOUT WITH AFTERPAY
    case (.whiteOnBlack, .checkout, Locales.greatBritain),
      (.mintOnBlack, .checkout, Locales.greatBritain):
      return .clearpayCheckoutWhiteOnBlack
    case (.blackOnMint, .checkout, Locales.greatBritain),
      (.blackOnWhite, .checkout, Locales.greatBritain):
      return .clearpayCheckoutBlackOnMint

    case (.mintOnBlack, .checkout, _),
      (.whiteOnBlack, .checkout, _):
      return .afterpayCheckoutWhiteOnBlack
    case (.blackOnMint, .checkout, _),
      (.blackOnWhite, .checkout, _):
      return .afterpayCheckoutBlackOnMint

    //PAY NOW WITH AFTERPAY
    case (.blackOnMint, .payNow, Locales.greatBritain):
      return .clearpayPayNowBlackOnMint
    case (.mintOnBlack, .payNow, Locales.greatBritain):
      return .clearpayPayNowMintOnBlack
    case (.whiteOnBlack, .payNow, Locales.greatBritain):
      return .clearpayPayNowWhiteOnBlack
    case (.blackOnWhite, .payNow, Locales.greatBritain):
      return .clearpayPayNowBlackOnWhite

    case (.blackOnMint, .payNow, _):
      return .afterpayPayNowBlackOnMint
    case (.mintOnBlack, .payNow, _):
      return .afterpayPayNowMintOnBlack
    case (.whiteOnBlack, .payNow, _):
      return .afterpayPayNowWhiteOnBlack
    case (.blackOnWhite, .payNow, _):
      return .afterpayPayNowBlackOnWhite

    //PLACE ORDER WITH AFTERPAY
    case (.whiteOnBlack, .placeOrder, Locales.greatBritain),
      (.mintOnBlack, .placeOrder, Locales.greatBritain):
      return .clearpayPlaceOrderWhiteOnBlack
    case (.blackOnMint, .placeOrder, Locales.greatBritain),
      (.blackOnWhite, .placeOrder, Locales.greatBritain):
      return .clearpayPlaceOrderBlackOnMint

    case (.mintOnBlack, .placeOrder, _),
      (.whiteOnBlack, .placeOrder, _):
      return .afterpayPlaceOrderWhiteOnBlack
    case (.blackOnMint, .placeOrder, _),
      (.blackOnWhite, .placeOrder, _):
      return .afterpayPlaceOrderBlackOnMint
    }
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
