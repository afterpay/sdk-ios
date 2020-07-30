//
//  BadgeView.swift
//  Afterpay
//
//  Created by Adam Campbell on 30/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
#if compiler(>=5.1) && compiler(<5.3)
@_implementationOnly import SwiftSVG
#else
import SwiftSVG
#endif
import UIKit

final class SVGView: UIView {

  var svgLayer: SVGLayer? { layer.sublayers?.first as? SVGLayer }

  init(svg: SVG, autolayout: Bool = true) {
    super.init(frame: CGRect(origin: .zero, size: svg.size))

    CALayer(SVGData: svg.data, completion: layer.addSublayer)

    if autolayout {
      translatesAutoresizingMaskIntoConstraints = false
      heightAnchor.constraint(equalTo: widthAnchor, multiplier: svg.aspectRatio).isActive = true
    }
  }

  public override func layoutSublayers(of layer: CALayer) {
    svgLayer?.resizeToFit(bounds)
  }

  // MARK: - Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
