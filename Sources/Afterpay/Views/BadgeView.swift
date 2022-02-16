//
//  BadgeView.swift
//  Afterpay
//
//  Created by Adam Campbell on 31/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

public final class BadgeView: LayeredImageView {
  override internal func sharedInit() {
    super.sharedInit()

    layers.background = "badge-background"
    setForeground()
  }

  override internal func setForeground() {
    if getLocale() == Locales.greatBritain {
      layers.foreground = "badge-foreground-clearpay"
    } else {
      layers.foreground = "badge-foreground-afterpay"
    }
  }
}
