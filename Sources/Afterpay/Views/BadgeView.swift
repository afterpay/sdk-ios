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
  internal var minimumWidth: CGFloat = 64

  override internal func sharedInit() {
    super.sharedInit()

    layers.background = "badge-background"
    setForeground()
  }

  override internal func setForeground() {
    let brand = getLocale() == Locales.greatBritain ? "clearpay" : "afterpay"
    layers.foreground = "badge-foreground-\(brand)"
  }
}
