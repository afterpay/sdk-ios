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

  var svg: SVG {
    didSet { svgDidChange() }
  }

  init(svg: SVG) {
    self.svg = svg

    super.init(node: svg.node, frame: CGRect(origin: .zero, size: svg.size))

    backgroundColor = .clear
    translatesAutoresizingMaskIntoConstraints = false
    setupAspectRatioConstraint()
  }

  private var aspectRatioConstraint: NSLayoutConstraint!

  private func setupAspectRatioConstraint() {
    aspectRatioConstraint = heightAnchor.constraint(
      equalTo: widthAnchor,
      multiplier: svg.aspectRatio
    )

    aspectRatioConstraint.isActive = true
  }

  private func svgDidChange() {
    node = svg.node

    if aspectRatioConstraint.multiplier != svg.aspectRatio {
      aspectRatioConstraint.isActive = false
      setupAspectRatioConstraint()
    }
  }

  // MARK: - Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
