//
//  LogoView.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 15/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class LogoView: UIView {

  private var svgView: SVGView!
  public init(colorScheme: ColorScheme = .static(.blackOnMint)) {
    super.init(frame: .zero)

    sharedInit(colorScheme: colorScheme)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    sharedInit()
  }

  private func sharedInit(colorScheme: ColorScheme = .static(.blackOnMint)) {
    let configuration = AfterpayLogoFullConfiguration(colorScheme: colorScheme)

    isAccessibilityElement = true
    accessibilityTraits = [.staticText]
    accessibilityLabel = configuration.accessibilityLabel(localizedFor: getLocale())

    svgView = SVGView(svgConfiguration: configuration)

    addSubview(svgView)

    NSLayoutConstraint.activate([
      svgView.leadingAnchor.constraint(equalTo: leadingAnchor),
      svgView.trailingAnchor.constraint(equalTo: trailingAnchor),
      svgView.topAnchor.constraint(equalTo: topAnchor),
      svgView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
}
