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
    case whiteOnBlack, blackOnWhite

    var svg: SVG {
      switch self {
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
    svgView = SVGView(svg: style(for: traitCollection).svg)

    addSubview(svgView)

    NSLayoutConstraint.activate([
      svgView.leadingAnchor.constraint(equalTo: leadingAnchor),
      svgView.trailingAnchor.constraint(equalTo: trailingAnchor),
      svgView.topAnchor.constraint(equalTo: topAnchor),
      svgView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    svgView.svg = style(for: traitCollection).svg
  }

  private func style(for traitCollection: UITraitCollection) -> Style {
    switch traitCollection.userInterfaceStyle {
    case .dark:
      return darkStyle
    case .light, .unspecified:
      fallthrough
    @unknown default:
      return lightStyle
    }
  }

}
