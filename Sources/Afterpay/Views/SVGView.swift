//
//  BadgeView.swift
//  Afterpay
//
//  Created by Adam Campbell on 30/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
#if compiler(>=5.1) && compiler(<5.4)
@_implementationOnly import Macaw
#else
import Macaw
#endif
import UIKit

final class SVGView: Macaw.SVGView {

  var svg: SVG { svg(for: traitCollection) }

  var svgConfiguration: SVGConfiguration {
    didSet { svgDidChange() }
  }

  init(svgConfiguration: SVGConfiguration) {
    self.svgConfiguration = svgConfiguration

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
    let locale = getConfiguration()?.locale ?? Locales.unitedStates
    return svgConfiguration.svg(localizedFor: locale, withTraits: traitCollection)
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
