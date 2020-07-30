//
//  SVG.swift
//  Afterpay
//
//  Created by Adam Campbell on 29/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
#if compiler(>=5.1) && compiler(<5.3)
@_implementationOnly import SwiftSVG
#else
import SwiftSVG
#endif
import QuartzCore

struct SVG {

  let size: CGSize
  let data: Data

  static let logoLockup: SVG = SVG(
    size: CGSize(width: 1869.6, height: 838.5),
    data: """
    <svg width="1869.6" height="838.5" viewBox="0 0 1869.6 838.5" fill="none" xmlns="http://www.w3.org/2000/svg">
    <rect x="360.6" y="308.93" width="1148.88" height="220.83" fill="black"/>
    </svg>
    """.data(using: .utf8)!
  )

  func render(completion: @escaping (SVGLayer) -> Void) {
    CALayer(SVGData: data) { svgLayer in
      // Construct a bounding box that includes the SVG size including inbuilt padding not just
      // enclosing the paths
      svgLayer.boundingBox = CGRect(origin: .zero, size: self.size)
      completion(svgLayer)
    }
  }

}
