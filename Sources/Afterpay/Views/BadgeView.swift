//
//  BadgeView.swift
//  Afterpay
//
//  Created by Adam Campbell on 31/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

public class BadgeView: AfterpayLogo {
  override public init(colorScheme: ColorScheme = .static(.default)) {
    if Afterpay.isCashAppAfterpayRegion {
      #if DEBUG
        assertionFailure("Cash App Afterpay compact badge is not supported")
      #endif
    }
    super.init(colorScheme: colorScheme)
    if Afterpay.isCashAppAfterpayRegion { self.isHidden = true }
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override internal func getImageName(brand: String, color: String) -> String {
    return "badge-\(brand)-\(color)"
  }

  override internal func getImageColor() -> String {
    var color = colorScheme.lightPalette.slug
    if traitCollection.userInterfaceStyle == .dark {
      color = colorScheme.darkPalette.slug
    }

    return color
  }
}
