//
//  BadgeView.swift
//  Afterpay
//
//  Created by Adam Campbell on 31/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

public final class BadgeView: UIView {

  public enum Style {
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

  private let lightStyle: Style
  private let darkStyle: Style

  private var svgView: SVGView!

  public convenience init(style: Style) {
    self.init(lightStyle: style, darkStyle: style)
  }

  public init(lightStyle: Style, darkStyle: Style) {
    self.lightStyle = lightStyle
    self.darkStyle = darkStyle

    super.init(frame: .zero)

    sharedInit()
  }

  required init?(coder: NSCoder) {
    self.lightStyle = .whiteOnBlack
    self.darkStyle = .blackOnWhite

    super.init(coder: coder)

    sharedInit()
  }

  private func sharedInit() {
    // Accessibility
    isAccessibilityElement = true
    accessibilityTraits = [.staticText]
    accessibilityLabel = "after pay"

    // SVG Layout
    svgView = SVGView(lightSVG: lightStyle.svg, darkSVG: darkStyle.svg)

    addSubview(svgView)

    NSLayoutConstraint.activate([
      svgView.leadingAnchor.constraint(equalTo: leadingAnchor),
      svgView.trailingAnchor.constraint(equalTo: trailingAnchor),
      svgView.topAnchor.constraint(equalTo: topAnchor),
      svgView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

}
