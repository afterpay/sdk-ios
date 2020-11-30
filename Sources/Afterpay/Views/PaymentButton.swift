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
    let locale = getConfiguration()?.locale ?? Locales.unitedStates
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
