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

  private var style: Style = .whiteOnBlack
  private var svgView: SVGView!

  public init(style: Style) {
    self.style = style

    super.init(frame: .zero)

    sharedInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    sharedInit()
  }

  private func sharedInit() {

    // Accessibility
    isAccessibilityElement = true
    accessibilityTraits = [.staticText]
    accessibilityLabel = "after pay"

    // SVG Layout
    svgView = SVGView(svg: style.svg)
    svgView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(svgView)

    NSLayoutConstraint.activate([
      svgView.leadingAnchor.constraint(equalTo: leadingAnchor),
      svgView.trailingAnchor.constraint(equalTo: trailingAnchor),
      svgView.topAnchor.constraint(equalTo: topAnchor),
      svgView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])

  }

}
