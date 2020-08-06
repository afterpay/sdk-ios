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

  var badgeSVGPair: SVGPair {
    let svg: (ColorPalette) -> SVG = { palette in
      switch palette {
      case .blackOnMint:
        return .badgeBlackOnMint
      case .mintOnBlack:
        return .badgeMintOnBlack
      case .whiteOnBlack:
        return .badgeWhiteOnBlack
      case .blackOnWhite:
        return .badgeBlackOnWhite
      }
    }

    return SVGPair(lightSVG: svg(lightPalette), darkSVG: svg(darkPalette))
  }
}

public enum ColorPalette {
  case blackOnMint
  case mintOnBlack
  case whiteOnBlack
  case blackOnWhite
}
