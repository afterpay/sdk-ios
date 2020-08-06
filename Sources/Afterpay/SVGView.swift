//
//  BadgeView.swift
//  Afterpay
//
//  Created by Adam Campbell on 30/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
#if compiler(>=5.1) && compiler(<5.3)
@_implementationOnly import Macaw
#else
import Macaw
#endif
import UIKit

final class SVGView: Macaw.SVGView {

  var svg: SVG { svg(for: traitCollection) }

  private let lightSVG: SVG
  private let darkSVG: SVG

  convenience init(svg: SVG) {
    self.init(lightSVG: svg, darkSVG: svg)
  }

  init(lightSVG: SVG, darkSVG: SVG) {
    self.lightSVG = lightSVG
    self.darkSVG = darkSVG

    super.init(frame: .zero)

    node = svg.node
    backgroundColor = .clear
    translatesAutoresizingMaskIntoConstraints = false
    setupConstraints()
  }

  private var aspectRatioConstraint: NSLayoutConstraint!
  private var minimumWidthConstraint: NSLayoutConstraint!

  private func setupConstraints() {
    aspectRatioConstraint = heightAnchor.constraint(
      equalTo: widthAnchor,
      multiplier: svg.aspectRatio
    )

    minimumWidthConstraint = widthAnchor.constraint(greaterThanOrEqualToConstant: svg.minimumWidth)

    NSLayoutConstraint.activate([aspectRatioConstraint, minimumWidthConstraint])
  }

  private func svg(for traitCollection: UITraitCollection) -> SVG {
    switch traitCollection.userInterfaceStyle {
    case .dark:
      return darkSVG
    case .light, .unspecified:
      fallthrough
    @unknown default:
      return lightSVG
    }
  }

  private func svgDidChange() {
    node = svg.node

    let aspectRatio = aspectRatioConstraint.multiplier
    let minimumWidth = minimumWidthConstraint.constant

    if aspectRatio != svg.aspectRatio || minimumWidth != svg.minimumWidth {
      NSLayoutConstraint.deactivate([aspectRatioConstraint, minimumWidthConstraint])
      setupConstraints()
    }
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if previousTraitCollection.map(svg) != svg(for: traitCollection) {
      svgDidChange()
    }
  }

  // MARK: - Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
