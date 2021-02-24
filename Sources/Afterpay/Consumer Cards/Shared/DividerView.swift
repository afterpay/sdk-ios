//
//  DividerView.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 24/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class DividerView: UIView {
  
  private let dashedLineLayer: CAShapeLayer = {
    let shapeLayer = CAShapeLayer()
    let lineDashPattern: [NSNumber] = [1, 2]

    shapeLayer.strokeColor = UIColor.black.cgColor
    shapeLayer.lineWidth = 1
    shapeLayer.lineDashPattern = lineDashPattern
 
    return shapeLayer
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: 1),
    ])
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func layoutSubviews() {
    if layer.sublayers?.contains(dashedLineLayer) ?? true {
      addDashedLinePath()
      layer.addSublayer(dashedLineLayer)
    }
  }

  private func addDashedLinePath() {
    let path = CGMutablePath()
    path.move(to: .zero)
    path.addLine(to: CGPoint(x: frame.width, y: .zero))

    dashedLineLayer.path = path
  }
}
