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
        return .clearpayBlackOnMint
      case (.mintOnBlack, Locales.greatBritain):
        return .clearpayMintOnBlack
      case (.whiteOnBlack, Locales.greatBritain):
        return .clearpayWhiteOnBlack
      case (.blackOnWhite, Locales.greatBritain):
        return .clearpayBlackOnWhite
      case (.blackOnMint, _):
        return .afterpayBlackOnMint
      case (.mintOnBlack, _):
        return .afterpayMintOnBlack
      case (.whiteOnBlack, _):
        return .afterpayWhiteOnBlack
      case (.blackOnWhite, _):
        return .afterpayBlackOnWhite
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
