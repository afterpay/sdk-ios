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

  public var colorScheme: ColorScheme = .static(.blackOnMint) {
    didSet { svgView.svgConfiguration.colorScheme = colorScheme }
  }

  private var svgView: SVGView!

  public init(colorScheme: ColorScheme = .static(.blackOnMint)) {
    self.colorScheme = colorScheme

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
    accessibilityLabel = Strings.accessibleAfterpay

    // SVG Layout
    svgView = SVGView(svgConfiguration: BadgeConfiguration())

    addSubview(svgView)

    NSLayoutConstraint.activate([
      svgView.leadingAnchor.constraint(equalTo: leadingAnchor),
      svgView.trailingAnchor.constraint(equalTo: trailingAnchor),
      svgView.topAnchor.constraint(equalTo: topAnchor),
      svgView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

}
