//
//  PaymentButtonUIView.swift
//  Afterpay
//
//  Created by Scott Antonac on 16/2/22.
//  Copyright © 2022 Afterpay. All rights reserved.
//

import Foundation
import UIKit

public final class PaymentButtonUIView: LayeredImageView {
  override internal func sharedInit() {
    super.sharedInit()

    layers.background = "button-background"
    setForeground()
  }

  override internal func setForeground() {
    if getLocale() == Locales.greatBritain {
      layers.foreground = "button-foreground-pay-now-clearpay"
    } else {
      layers.foreground = "button-foreground-pay-now-afterpay"
    }
  }
}
