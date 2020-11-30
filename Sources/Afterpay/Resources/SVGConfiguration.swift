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

}
