//
//  BadgeView.swift
//  Afterpay
//
//  Created by Adam Campbell on 30/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
#if compiler(>=5.1) && compiler(<5.5)
@_implementationOnly import Macaw
#else
import Macaw
#endif
import UIKit

final class SVGView: Macaw.SVGView {

  var svg: SVG { svgConfiguration.svg(localizedFor: getLocale(), withTraits: traitCollection) }

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

    let selector = #selector(configurationDidChange)
    let name: NSNotification.Name = .configurationUpdated
    notificationCenter.addObserver(self, selector: selector, name: name, object: nil)
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

  private func svgDidChange() {
    node = svg.node

    let aspectRatio = aspectRatioConstraint.multiplier
    let minimumWidth = minimumWidthConstraint.constant

    if aspectRatio != svg.aspectRatio || minimumWidth != svg.minimumWidth {
      NSLayoutConstraint.deactivate([aspectRatioConstraint, minimumWidthConstraint])
      setupConstraints()
    }
  }

  @objc private func configurationDidChange(_ notification: NSNotification) {
    let previousLocale = (notification.object as? Configuration)?.locale ?? Locales.unitedStates

    DispatchQueue.main.async {
      self.updateSvgLocale(previousLocale: previousLocale)
    }
  }

  private func updateSvgLocale(previousLocale: Locale) {
    let svgForLocale = { [traitCollection, svgConfiguration] locale in
      svgConfiguration.svg(localizedFor: locale, withTraits: traitCollection)
    }

    if svgForLocale(previousLocale) != svgForLocale(getLocale()) {
      svgDidChange()
    }
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    let svgForTraits = { [svgConfiguration] traitCollection in
      svgConfiguration.svg(localizedFor: getLocale(), withTraits: traitCollection)
    }

    if previousTraitCollection.map(svgForTraits) != svgForTraits(traitCollection) {
      svgDidChange()
    }
  }

  // MARK: - Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
