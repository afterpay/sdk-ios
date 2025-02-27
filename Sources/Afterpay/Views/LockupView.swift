//
//  LockupView.swift
//  Afterpay
//
//  Created by Scott Antonac on 6/4/2022.
//  Copyright © 2022 Afterpay. All rights reserved.
//

import Foundation
import UIKit

public class LockupView: AfterpayLogo {
  override public init(colorScheme: ColorScheme = .static(.default)) {
    super.init(colorScheme: colorScheme)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override internal func getImageName(brand: String, color: String) -> String {
    return "lockup-\(brand)-\(color)"
  }

  override internal func getImageColor() -> String {
    guard Afterpay.isCashAppAfterpayRegion else {
      var color = colorScheme.lightPalette.foreground
      if traitCollection.userInterfaceStyle == .dark {
        color = colorScheme.darkPalette.foreground
      }
      return color
    }
    var color = colorScheme.lightPalette.foregroundCashAppAfterpay
    if traitCollection.userInterfaceStyle == .dark {
      color = colorScheme.darkPalette.foregroundCashAppAfterpay
    }
    return color
  }
}
