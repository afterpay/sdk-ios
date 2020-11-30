//
//  PaymentButton.swift
//  Afterpay
//
//  Created by Adam Campbell on 27/11/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

public final class PaymentButton: UIButton {

  public var colorScheme: ColorScheme = .static(.blackOnMint) {
    didSet { renderImage() }
  }

  private var configuration: SVGConfiguration {
    PaymentButtonConfiguration(colorScheme: colorScheme)
  }

  private var locale: Locale { getConfiguration()?.locale ?? Locales.unitedStates }

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
    let svg = configuration.svg(localizedFor: locale, withTraits: traitCollection)

    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalTo: widthAnchor, multiplier: svg.aspectRatio),
      widthAnchor.constraint(greaterThanOrEqualToConstant: svg.minimumWidth),
    ])

    translatesAutoresizingMaskIntoConstraints = false
    adjustsImageWhenHighlighted = true
    adjustsImageWhenDisabled = true
  }

  private var previousBounds: CGRect = .zero

  public override func layoutSubviews() {
    super.layoutSubviews()

    if bounds != previousBounds {
      renderImage()
      previousBounds = bounds
    }
  }

  public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    let svgForTraits = { [locale, configuration] traitCollection in
      configuration.svg(localizedFor: locale, withTraits: traitCollection)
    }

    if previousTraitCollection.map(svgForTraits) != svgForTraits(traitCollection) {
      renderImage()
    }
  }

  private func renderImage() {
    let svgView = SVGView(svgConfiguration: configuration)
    svgView.frame = bounds

    let renderer = UIGraphicsImageRenderer(size: svgView.bounds.size)
    let image = renderer.image { rendererContext in
      svgView.layer.render(in: rendererContext.cgContext)
    }

    setImage(image, for: .normal)
  }

}
