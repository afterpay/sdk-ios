//
//  SVG.swift
//  Afterpay
//
//  Created by Adam Campbell on 29/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
#if compiler(>=5.1) && compiler(<5.5)
@_implementationOnly import Macaw
#else
import Macaw
#endif
import UIKit

struct SVG: Equatable {

  let size: CGSize
  let minimumWidth: CGFloat
  private let svgString: String

  var aspectRatio: CGFloat { size.height / size.width }
  var node: Node { (try? SVGParser.parse(text: svgString)) ?? Group() }

  init(size: CGSize, minimumWidth: CGFloat, svgString: String) {
    self.size = size
    self.minimumWidth = minimumWidth
    self.svgString = svgString
  }

  static func badge(palette: ColorPalette, locale: Locale) -> SVG {
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

  static func buyNow(palette: ColorPalette, locale: Locale) -> SVG {
    switch (palette, locale) {
    case (.blackOnMint, Locales.greatBritain), (.blackOnWhite, Locales.greatBritain):
      return .clearpayBuyNowBlackOnMint
    case (.whiteOnBlack, Locales.greatBritain), (.mintOnBlack, Locales.greatBritain):
      return .clearpayBuyNowWhiteOnBlack
    case (.blackOnMint, _), (.blackOnWhite, _):
      return .afterpayBuyNowBlackOnMint
    case (.whiteOnBlack, _), (.mintOnBlack, _):
      return .afterpayBuyNowWhiteOnBlack
    }
  }

  static func checkout(palette: ColorPalette, locale: Locale) -> SVG {
    switch (palette, locale) {
    case (.blackOnMint, Locales.greatBritain), (.blackOnWhite, Locales.greatBritain):
      return .clearpayCheckoutBlackOnMint
    case (.whiteOnBlack, Locales.greatBritain), (.mintOnBlack, Locales.greatBritain):
      return .clearpayCheckoutWhiteOnBlack
    case (.blackOnMint, _), (.blackOnWhite, _):
      return .afterpayCheckoutBlackOnMint
    case (.whiteOnBlack, _), (.mintOnBlack, _):
      return .afterpayCheckoutWhiteOnBlack
    }
  }

  static func payNow(palette: ColorPalette, locale: Locale) -> SVG {
    switch (palette, locale) {
    case (.blackOnMint, Locales.greatBritain), (.blackOnWhite, Locales.greatBritain):
      return .clearpayPayNowBlackOnMint
    case (.whiteOnBlack, Locales.greatBritain), (.mintOnBlack, Locales.greatBritain):
      return .clearpayPayNowWhiteOnBlack
    case (.blackOnMint, _), (.blackOnWhite, _):
      return .afterpayPayNowBlackOnMint
    case (.whiteOnBlack, _), (.mintOnBlack, _):
      return .afterpayPayNowWhiteOnBlack
    }
  }

  static func placeOrder(palette: ColorPalette, locale: Locale) -> SVG {
    switch (palette, locale) {
    case (.blackOnMint, Locales.greatBritain), (.blackOnWhite, Locales.greatBritain):
      return .clearpayPlaceOrderBlackOnMint
    case (.whiteOnBlack, Locales.greatBritain), (.mintOnBlack, Locales.greatBritain):
      return .clearpayPlaceOrderWhiteOnBlack
    case (.blackOnMint, _), (.blackOnWhite, _):
      return .afterpayPlaceOrderBlackOnMint
    case (.whiteOnBlack, _), (.mintOnBlack, _):
      return .afterpayPlaceOrderWhiteOnBlack
    }
  }
}
