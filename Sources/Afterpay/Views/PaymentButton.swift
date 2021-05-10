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
    didSet { updateImage() }
  }

  public var buttonKind: ButtonKind = .buyNow {
    didSet { updateImage() }
  }

  private var configuration: SVGConfiguration {
    PaymentButtonConfiguration(colorScheme: colorScheme, buttonKind: buttonKind)
  }

  public init(colorScheme: ColorScheme = .static(.blackOnMint), buttonKind: ButtonKind = .payNow) {
    self.colorScheme = colorScheme
    self.buttonKind = buttonKind

    super.init(frame: .zero)

    sharedInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    sharedInit()
  }

  private func sharedInit() {
    let locale = getLocale()
    let svg = configuration.svg(localizedFor: locale, withTraits: traitCollection)

    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalTo: widthAnchor, multiplier: svg.aspectRatio),
      widthAnchor.constraint(greaterThanOrEqualToConstant: svg.minimumWidth),
    ])

    accessibilityLabel = configuration.accessibilityLabel(localizedFor: locale)
    translatesAutoresizingMaskIntoConstraints = false
    adjustsImageWhenHighlighted = true
    adjustsImageWhenDisabled = true
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    if image(for: .normal)?.size != bounds.size {
      updateImage()
    }
  }

  public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    let svgForTraits = { [configuration] traitCollection in
      configuration.svg(localizedFor: getLocale(), withTraits: traitCollection)
    }

    if previousTraitCollection.map(svgForTraits) != svgForTraits(traitCollection) {
      updateImage()
    }
  }

  private func updateImage() {
    let svgView = SVGView(svgConfiguration: configuration)
    svgView.frame = bounds

    let renderer = UIGraphicsImageRenderer(size: svgView.bounds.size)
    let image = renderer.image { rendererContext in
      svgView.layer.render(in: rendererContext.cgContext)
    }

    setImage(image, for: .normal)
  }

}
