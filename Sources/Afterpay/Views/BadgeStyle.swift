//
//  BadgeStyle.swift
//  Afterpay
//
//  Created by Adam Campbell on 5/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

public enum BadgeStyle {
  case blackOnMint
  case mintOnBlack
  case whiteOnBlack
  case blackOnWhite

  var svg: SVG {
    switch self {
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
}
